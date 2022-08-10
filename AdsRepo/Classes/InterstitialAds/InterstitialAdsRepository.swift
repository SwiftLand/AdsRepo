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
    
    internal var errorHandler:ErrorHandler = ErrorHandler()
    internal var adCreator:ADCreatorProtocol = ADCreator()
    
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
    
    let notValidCondition:((InterstitialAdWrapper) -> Bool) = {
        
        return ($0.now-($0.loadedDate ?? $0.now) > $0.config.expireIntervalTime) || $0.showCount>=$0.config.showCountThreshold
    }
    
    public init(config:RepoConfig,
                errorHandlerConfig:ErrorHandlerConfig? = nil,
                delegate:InterstitialAdsRepositoryDelegate? = nil){
        
        self.config = config
        self.delegate = delegate
        
        if let eConfig = errorHandlerConfig{
            self.errorHandler = ErrorHandler(config:eConfig)
        }
        
        super.init()
    }
    
    public func validateRepositoryAds(){
        let ads = adsRepo.filter(notValidCondition)
        adsRepo.removeAll(where: notValidCondition)
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
        
        while adsRepo.count<totalAdsNeedCount {
            adsRepo.append(adCreator.createAd(owner: self))
            adsRepo.last?.loadAd()
        }
    }
    
    public func presentAd(vc:UIViewController,willLoad:((InterstitialAdWrapper?)->Void)? = nil){
        validateRepositoryAds()
        guard let adWrapper = adsRepo.min(by: {$0.showCount < $1.showCount})
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
