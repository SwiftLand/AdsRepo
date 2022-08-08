//
//  NativeAdsRepository.swift
//  AdRepo
//
//  Created by Ali on 9/2/21.
//

import Foundation
import GoogleMobileAds

public protocol NativeAdsRepositoryDelegate:NSObject{
    func nativeAdsRepository(didReceive repo:NativeAdsRepository)
    func nativeAdsRepository(didFinishLoading repo:NativeAdsRepository,error:Error?)
}
extension NativeAdsRepositoryDelegate{
    public func nativeAdsRepository(didReceive repo:NativeAdsRepository){}
    public func nativeAdsRepository(didFinishLoading repo:NativeAdsRepository,error:Error?){}
}
public class NativeAdsRepository:NSObject,AdsRepoProtocol{
    
    public let identifier:String
    fileprivate var errorHandler:ErrorHandler
    public private(set) var config:RepoConfig
    private weak var rootVC:UIViewController? = nil
    public fileprivate(set) var adsRepo:[NativeAdWrapper] = []
    public private(set) var adLoaderOptions: [GADAdLoaderOptions]?
    public private(set) var adTypes:[GADAdLoaderAdType]?
    public var autoFill:Bool = true
    public  var isLoading:Bool {
        adLoader?.isLoading ?? false
    }
    
    public  var isDisable:Bool = false{
        didSet{
            if isDisable{
                adsRepo.removeAll()
                stopLoading()
            }else{
                fillRepoAds()
            }
        }
    }
    
    var hasReadyAd:Bool{
        validateRepositoryAds()
        return adsRepo.count > 0
    }
    
    weak var delegate:NativeAdsRepositoryDelegate? = nil
    private var adLoader: GADAdLoader?
    private var onCompleteLoading:(()->Void)? = nil
    private lazy var listener:AdLoaderListener = {
        AdLoaderListener(owner: self)
    }()
    
    private let notValidAdCondition:((NativeAdWrapper) -> Bool) = {
        (Date().timeIntervalSince1970-$0.loadedDate > $0.config.expireIntervalTime) || $0.showCount>=$0.config.showCountThreshold
        
    }
    
    public init(identifier:String,config:RepoConfig,
                errorHandlerConfig:ErrorHandlerConfig? = nil,
                delegate:NativeAdsRepositoryDelegate? = nil){
        
        self.identifier = identifier
        self.delegate = delegate
        self.config = config
        self.errorHandler = ErrorHandler(config: errorHandlerConfig)
        super.init()
    }
    
    public func adLoaderConfig(adLoaderOptions:[GADAdLoaderOptions],
                               adTypes:[GADAdLoaderAdType]? = nil,
                               rootVC:UIViewController? = nil){
        // Create multiple ads ad loader options
        self.adLoaderOptions = adLoaderOptions
        self.rootVC = rootVC
        configAdLoader()
    }
    
    private func configAdLoader(){
     
        var adLoaderOptions = adLoaderOptions ?? []
        
        //multiAdOption have to control from repository
        adLoaderOptions.removeAll(where:{$0 is GADMultipleAdsAdLoaderOptions})
        let multiAdOption = GADMultipleAdsAdLoaderOptions()
        multiAdOption.numberOfAds = config.repoSize - adsRepo.count
        adLoaderOptions.append(multiAdOption)
        
        
        let vc = rootVC ?? UIApplication.shared.keyWindow?.rootViewController
        // Create GADAdLoader
        adLoader = GADAdLoader(
            adUnitID:config.adUnitId,
            rootViewController: vc,
            adTypes: adTypes ?? [.native],
            options: adLoaderOptions
        )
        // Set the GADAdLoader delegate
        adLoader?.delegate = listener
    }
    @discardableResult
    public func fillRepoAds()->Bool{
        guard !isDisable else {return false}
        
        guard adsRepo.count == 0 || adsRepo.contains(where: notValidAdCondition)
        else {return false}
        
        guard !(adLoader?.isLoading ?? false) else{return false}
        
        configAdLoader()
        adLoader?.load(GADRequest())
        return true
    }
    
    public func loadAd(loadFromRepo:@escaping ((NativeAdWrapper?)->Void)){
        
        guard autoFill,adsRepo.count>0 else {
            loadFromRepo(nil)
            fillRepoAds()
            return
        }
        
        let ad = adsRepo.min(by: {$0.showCount<$1.showCount})
        ad?.increaseShowCount()
        loadFromRepo(ad)
    }
    
    public func validateRepositoryAds(){
        let ads = adsRepo.filter(notValidAdCondition)
        adsRepo.removeAll(where: notValidAdCondition)
        ads.forEach({$0.removeFromRepository()})
    }
    
    private func removeAd(ad: NativeAdWrapper){//call when ad expire
          adsRepo.removeAll(where: {$0 == ad})
          ad.removeFromRepository()
    }
    
    func notifyAdChange(){
        if autoFill{
            fillRepoAds()
        }
    }
    
    public func stopLoading() {
        errorHandler.cancel()
        adLoader?.delegate = nil
        adLoader = nil
    }
}

private class AdLoaderListener:NSObject,GADNativeAdLoaderDelegate{
    weak var owner:NativeAdsRepository?
    init(owner:NativeAdsRepository) {
        self.owner = owner
    }
    public func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADNativeAd) {
        print("Native AdLoader","did Receive ads")
        guard let owner = owner else {return}
        
        owner.adsRepo.append(NativeAdWrapper(loadedAd: nativeAd,owner: owner))
        owner.delegate?.nativeAdsRepository(didReceive: owner)
        AdsRepo.default.nativeAdsRepository(didReceive: owner)
    }
    
    public func adLoaderDidFinishLoading(_ adLoader: GADAdLoader) {
        print("Native AdLoader","DidFinishLoading")
        guard let owner = owner else {return}
        owner.validateRepositoryAds()
        if !owner.autoFill || !owner.fillRepoAds(){
            owner.delegate?.nativeAdsRepository(didFinishLoading:owner,error:nil)
            AdsRepo.default.nativeAdsRepository(didFinishLoading:owner,error:nil)
        }
    }
    
    public func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
        print("Native AdLoader","error:",error)
        guard let owner = owner else {return}
        
        if owner.errorHandler.isRetryAble(error: error),!owner.isLoading{
            if owner.autoFill {
                owner.fillRepoAds()
            }
        }else{
            owner.delegate?.nativeAdsRepository(didFinishLoading:owner, error: error)
            AdsRepo.default.nativeAdsRepository(didFinishLoading:owner, error: error)
        }
    }
}
extension NativeAdsRepository {
    static func == (lhs: NativeAdsRepository, rhs: NativeAdsRepository) -> Bool{
        lhs.identifier == rhs.identifier
    }
}
