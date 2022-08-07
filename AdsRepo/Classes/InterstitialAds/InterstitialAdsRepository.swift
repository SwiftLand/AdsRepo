//
//  InterstitialAdContoller.swift
//  AdRepo
//
//  Created by ali khajehpour on 10/27/20.
//

import Foundation
import GoogleMobileAds

public protocol InterstitialAdsRepositoryDelegate:NSObject {
    func interstitialAdsRepository(didReceive repo:InterstitialAdsRepository)
    func interstitialAdsRepository(didFinishLoading repo:InterstitialAdsRepository,error:Error?)
}

extension InterstitialAdsRepositoryDelegate {
    public func interstitialAdsRepository(didReceive repo:InterstitialAdsRepository){}
    public func interstitialAdsRepository(didFinishLoading repo:InterstitialAdsRepository,error:Error?){}
}

public class InterstitialAdsRepository:NSObject,AdsRepoProtocol{
    
    public let identifier:String
    private var errorHandler:ErrorHandler
    public var isLoading:Bool {adsRepo.contains(where: {$0.isLoading})}
    public private(set) var adsRepo:[InterstitialAdWrapper] = []
    public private(set) var config:RepoConfig
    public var autoFill:Bool = true
    public var isDisable:Bool = false{
        didSet{
            if isDisable{
                errorHandler.cancel()
                let ads = adsRepo
                adsRepo.removeAll()
                ads.forEach({$0.delegate?.interstitialAdWrapper(didRemoveFromRepository: $0)})
            }else{
                if autoFill {
                    fillRepoAds()
                }
            }
        }
    }
    weak var delegate:InterstitialAdsRepositoryDelegate? = nil
    
    public init(identifier:String,config:RepoConfig,
                errorHandlerConfig:ErrorHandlerConfig? = nil,
                delegate:InterstitialAdsRepositoryDelegate? = nil){
        self.identifier = identifier
        self.config = config
        self.delegate = delegate
        self.errorHandler = ErrorHandler(config:errorHandlerConfig)
        super.init()
    }
    
    public func validateRepositoryAds(){
        let now = Date().timeIntervalSince1970
        let condition:((InterstitialAdWrapper) -> Bool) = {
            [unowned self] in
            (now-($0.loadedDate ?? now) > config.expireIntervalTime) || $0.showCount>=config.showCountThreshold
            
        }
        
        let ads = adsRepo.filter(condition)
        adsRepo.removeAll(where: condition)
        ads.forEach({$0.delegate?.interstitialAdWrapper(didRemoveFromRepository: $0)})
    }
    
    private func removeAd(ad: InterstitialAdWrapper){//call when ad expire
        adsRepo.removeAll(where: {$0 == ad})
        ad.delegate?.interstitialAdWrapper(didRemoveFromRepository: ad)
    }
    
    public func fillRepoAds(){
        guard !isDisable else{return}
        let loadingAdsCount = adsRepo.filter({$0.isLoading}).count
        let totalAdsNeedCount = config.repoSize-loadingAdsCount
        while adsRepo.count<totalAdsNeedCount{
            adsRepo.append(InterstitialAdWrapper(owner: self))
            adsRepo.last?.loadAd()
        }
    }
    
    public func presentAd(vc:UIViewController,willLoad:((InterstitialAdWrapper?)->Void)? = nil){
        validateRepositoryAds()
        let now = Date().timeIntervalSince1970
        guard let adWrapper = adsRepo.min(by: {($0.loadedDate ?? now) < ($1.loadedDate ?? now)})
        else{
            willLoad?(nil)
            if autoFill{
                fillRepoAds()
            }
            return
        }
        adWrapper.increaseShowCount()
        willLoad?(adWrapper)
        adWrapper.presentAd(vc: vc)
        
        if autoFill{
            fillRepoAds()
        }
    }
    
    public func hasReadyAd(vc:UIViewController)->Bool{
        validateRepositoryAds()
        return  adsRepo.first(where: {$0.isReady(vc: vc)}) != nil
    }
    
}

extension InterstitialAdsRepository{
    //will call from InterstitialAdWrapper
    
    func interstitialAdWrapper(didReady ad:InterstitialAdWrapper) {
        errorHandler.restart()
        delegate?.interstitialAdsRepository(didReceive: self)
        AdsRepo.default.interstitialAdsRepository(didReceive: self)
        if !adsRepo.contains(where: {!$0.isLoaded}){
            delegate?.interstitialAdsRepository(didFinishLoading: self, error: nil)
            AdsRepo.default.interstitialAdsRepository(didFinishLoading: self, error: nil)
        }
    }
    
    func interstitialAdWrapper(didClose ad:InterstitialAdWrapper) {
        removeAd(ad: ad)
    }
    
    func interstitialAdWrapper(onError ad:InterstitialAdWrapper, error: Error?) {
        removeAd(ad: ad)
        if errorHandler.isRetryAble(error: error),!isLoading{
            fillRepoAds()
        }else{
            delegate?.interstitialAdsRepository(didFinishLoading: self, error: error)
            AdsRepo.default.interstitialAdsRepository(didFinishLoading: self, error: error)
        }
    }
    func interstitialAdWrapper(didExpire ad: InterstitialAdWrapper) {
        removeAd(ad: ad)
        if autoFill {
            fillRepoAds()
        }
    }
}

extension InterstitialAdsRepository {
    static func == (lhs: InterstitialAdsRepository, rhs: InterstitialAdsRepository) -> Bool{
        lhs.identifier == rhs.identifier
    }
}

