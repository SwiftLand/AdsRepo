//
//  NativeAdRepository.swift
//  AdRepo
//
//  Created by Ali on 9/2/21.
//

import Foundation
import GoogleMobileAds

public protocol NativeAdRepositoryDelegate:NSObject{
    func nativeAdRepository(didReceive repo:NativeAdRepository)
    func nativeAdRepository(didFinishLoading repo:NativeAdRepository,error:Error?)
}
extension NativeAdRepositoryDelegate{
    public func nativeAdRepository(didReceive repo:NativeAdRepository){}
    public func nativeAdRepository(didFinishLoading repo:NativeAdRepository,error:Error?){}
}
public class NativeAdRepository:NSObject,AdsRepoProtocol{
    
    internal var errorHandler:ErrorHandler = ErrorHandler()
    internal var adCreator:AdCreatorProtocol = AdCreator()
    internal var adLoaderCreator:AdLoaderCreatorProtocol = AdLoaderCreator()
    
    public private(set) var config:RepositoryConfig
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
                let ads = adsRepo
                adsRepo.removeAll()
                ads.forEach({$0.delegate?.nativeAdWrapper(didRemoveFromRepository: $0)})
            }else{
                fillRepoAds()
            }
        }
    }
    
    private let notValidAdCondition:((NativeAdWrapper) -> Bool) = {
        print("notValidAdCondition",$0.now,$0.loadedDate,$0.config.expireIntervalTime,$0.now-$0.loadedDate > $0.config.expireIntervalTime,$0.showCount>=$0.config.showCountThreshold)
        return ($0.now-$0.loadedDate > $0.config.expireIntervalTime) || $0.showCount>=$0.config.showCountThreshold
        
    }
    
    var hasAd:Bool{
        return adsRepo.count > 0
    }
    var hasValidAd:Bool{
        return adsRepo.contains(where: {!notValidAdCondition($0)})
    }
    var hasUnvalidAd:Bool{
        return adsRepo.contains(where: notValidAdCondition)
    }
    
    weak var delegate:NativeAdRepositoryDelegate? = nil
    private var adLoader: GADAdLoader?
    private var onCompleteLoading:(()->Void)? = nil
    private lazy var listener:AdLoaderListener = {
        AdLoaderListener(owner: self)
    }()
    
    
    
    public init(config:RepositoryConfig,
                errorHandlerConfig:ErrorHandlerConfig? = nil,
                delegate:NativeAdRepositoryDelegate? = nil){
        
        self.delegate = delegate
        self.config = config
        if let eConfig = errorHandlerConfig{
            self.errorHandler = ErrorHandler(config:eConfig)
        }
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
        multiAdOption.numberOfAds = config.size - adsRepo.count
        adLoaderOptions.append(multiAdOption)
        
        
        let vc = rootVC ?? UIApplication.shared.keyWindow?.rootViewController
        // Create GADAdLoader
        adLoader = adLoaderCreator.create(adUnitId: config.adUnitId,
                                          rootViewController: vc,
                                          adLoaderOptions: adLoaderOptions,
                                          adTypes: adTypes)
        // Set the GADAdLoader delegate
        adLoader?.delegate = listener
    }
    @discardableResult
    public func fillRepoAds()->Bool{
        guard !isDisable else {return false}
        
        guard adsRepo.count < config.size || adsRepo.contains(where: notValidAdCondition)
        else {return false}
        
        guard !(adLoader?.isLoading ?? false) else{return false}
        
        configAdLoader()
        adLoader?.load(GADRequest())
        return true
    }
    
    @discardableResult
    public func loadAd(loadFromRepo:@escaping ((NativeAdWrapper?)->Void))->Bool{
        
        guard autoFill,adsRepo.count>0 else {
            loadFromRepo(nil)
            fillRepoAds()
            return false
        }
        
        let ad = adsRepo.min(by: {$0.showCount<$1.showCount})
        ad?.increaseShowCount()
        loadFromRepo(ad)
        notifyAdChange()
        return true
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
    weak var owner:NativeAdRepository?
    init(owner:NativeAdRepository) {
        self.owner = owner
    }
    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADNativeAd) {
        print("Native AdLoader","did Receive ads")
        guard let owner = owner else {return}
        
        owner.adsRepo.append(owner.adCreator.createAd(loadedAd: nativeAd,owner: owner))
        owner.delegate?.nativeAdRepository(didReceive: owner)
        AdsRepo.default.nativeAdRepository(didReceive: owner)
    }
    
    func adLoaderDidFinishLoading(_ adLoader: GADAdLoader) {
        print("Native AdLoader","DidFinishLoading")
        guard let owner = owner else {return}
        owner.validateRepositoryAds()
        if !owner.autoFill || !owner.fillRepoAds(){
            owner.delegate?.nativeAdRepository(didFinishLoading:owner,error:nil)
            AdsRepo.default.nativeAdRepository(didFinishLoading:owner,error:nil)
        }
    }
    
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
        print("Native AdLoader","error:",error)
        guard let owner = owner else {return}
        
        if owner.errorHandler.isRetryAble(error: error),!owner.isLoading{
            if owner.autoFill {
                owner.fillRepoAds()
            }
        }else{
            owner.delegate?.nativeAdRepository(didFinishLoading:owner, error: error)
            AdsRepo.default.nativeAdRepository(didFinishLoading:owner, error: error)
        }
    }
}
