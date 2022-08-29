//
//  InterstitialAdContoller.swift
//  AdRepo
//
//  Created by ali khajehpour on 10/27/20.
//

import Foundation
import GoogleMobileAds


public class InterstitialAdRepository:NSObject,AdsRepoProtocol{
    
    internal var errorHandler:ErrorHandlerProtocol = ErrorHandler()
    internal var adCreator:AdCreatorProtocol = AdCreator()
    
    public var isLoading:Bool {adsRepo.contains(where: {$0.state == .loading})}
    public private(set) var adsRepo:[InterstitialAdWrapper] = []
    public private(set) var config:RepositoryConfig
    public var autoFill:Bool = true
    public var isDisable:Bool = false{
        didSet{
            if isDisable{
                errorHandler.cancel()
                removeAllAds()
            }else{
                if autoFill {
                    fillRepoAds()
                }
            }
        }
    }
    weak var delegate:InterstitialAdRepositoryDelegate? = nil
    
    let notValidCondition:((InterstitialAdWrapper) -> Bool) = {
        
        return ($0.now-($0.loadedDate ?? $0.now) > $0.config.expireIntervalTime) || $0.showCount>=$0.config.showCountThreshold
    }
    
    var hasValidAd:Bool{
        adsRepo.contains(where: {!notValidCondition($0)})
    }
    var validAdCount:Int{
        adsRepo.filter({!notValidCondition($0)}).count
    }
    
    public init(config:RepositoryConfig,
                errorHandlerConfig:ErrorHandlerConfig? = nil,
                delegate:InterstitialAdRepositoryDelegate? = nil){
        
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
    
    private func removeAd(ad: InterstitialAdWrapper){
        adsRepo.removeAll(where: {$0 == ad})
        ad.delegate?.interstitialAdWrapper(didRemoveFromRepository: ad)
    }
    
    private func removeAllAds(where condition: ((InterstitialAdWrapper) -> Bool)? = nil){
        var ads:[InterstitialAdWrapper] = []
        if let condition = condition {
            ads = adsRepo.filter(condition)
            adsRepo.removeAll(where:condition)
        }else{
            ads = adsRepo
            adsRepo.removeAll()
        }
        ads.forEach({$0.delegate?.interstitialAdWrapper(didRemoveFromRepository: $0)})
    }
    
    public func fillRepoAds(){
        guard !isDisable else{return}
        let loadingAdsCount = adsRepo.filter({$0.state == .loading}).count
        let notValidAdsCount = adsRepo.filter(notValidCondition).count
        let totalAdsNeedCount = (config.size - loadingAdsCount) + notValidAdsCount
        while adsRepo.count<totalAdsNeedCount {
            let ad = adCreator.createAd(owner: self)
            adsRepo.append(ad)
            ad.loadAd()
        }
    }
    @discardableResult
    public func presentAd(vc:UIViewController,willLoad:((InterstitialAdWrapper?)->Void)? = nil)->Bool{
        guard let adWrapper = adsRepo.min(by: {$0.showCount < $1.showCount})
        else{
            willLoad?(nil)
            if autoFill{
                fillRepoAds()
            }
            return false
        }
        adWrapper.increaseShowCount()
        willLoad?(adWrapper)
        adWrapper.presentAd(vc: vc)
        
        if autoFill{
            fillRepoAds()
        }
        return true
    }

    public func hasReadyAd(vc:UIViewController)->Bool{
        return  adsRepo.first(where: {$0.isReady(vc: vc)}) != nil
    }
    
}


extension InterstitialAdRepository:InterstitialAdOwnerDelegate{
    
    func adWrapper(didReady ad:InterstitialAdWrapper) {
        errorHandler.restart()
        if let ad = adsRepo.first(where: {notValidCondition($0) && !$0.isPresenting}) {
            removeAd(ad: ad)
        }
        delegate?.interstitialAdRepository(didReceive: self)
        AdsRepo.default.interstitialAdRepository(didReceive: self)

        if !adsRepo.contains(where: {$0.state != .loaded}) && validAdCount == config.size{
            delegate?.interstitialAdRepository(didFinishLoading: self, error: nil)
            AdsRepo.default.interstitialAdRepository(didFinishLoading: self, error: nil)
        }
    }
    
    func adWrapper(didClose ad:InterstitialAdWrapper) {
        if let ad = adsRepo.first(where: notValidCondition) {
            removeAd(ad: ad)
        }
    }
    
    func adWrapper(onError ad:InterstitialAdWrapper, error: Error?) {
        removeAd(ad: ad)
        let isRetryAble = errorHandler.isRetryAble(error: error){[weak self] in
            self?.fillRepoAds()//add new ads but not load them
        }
        
        guard !isRetryAble  else{return}
        
        if  !adsRepo.contains(where: {$0.state != .error}){//if load all ads failed
            removeAllAds(where: {$0.state == .error})
            delegate?.interstitialAdRepository(didFinishLoading: self, error: error)
            AdsRepo.default.interstitialAdRepository(didFinishLoading: self, error: error)
        }
        
    }
    func adWrapper(didExpire ad: InterstitialAdWrapper) {
        if autoFill {
            fillRepoAds()
        }
    }
}
