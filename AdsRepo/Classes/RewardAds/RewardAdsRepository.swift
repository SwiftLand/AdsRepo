//
//  RewardedAdsRepository.swift
//  AdRepo
//
//  Created by Ali on 9/1/21.
//

import Foundation
import GoogleMobileAds


public class RewardedAdRepository:NSObject,AdsRepoProtocol{
    
    internal var errorHandler:ErrorHandlerProtocol = ErrorHandler()
    internal var adCreator:AdCreatorProtocol = AdCreator()
    
    public internal(set) var adsRepo:[RewardedAdWrapper] = []
    public private(set) var config:RepositoryConfig
    public var isLoading:Bool {adsRepo.contains(where: {$0.state == .loading})}
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
    weak var delegate:RewardedAdRepositoryDelegate? = nil
    
    let notValidCondition:((RewardedAdWrapper) -> Bool) = {
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
                delegate:RewardedAdRepositoryDelegate? = nil){
        
        self.delegate = delegate
        self.config = config
        if let eConfig = errorHandlerConfig{
            self.errorHandler = ErrorHandler(config:eConfig)
        }
        super.init()
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
    
    private func removeAd(ad: RewardedAdWrapper){//call when ad expire
           adsRepo.removeAll(where: {$0 == ad})
           ad.delegate?.rewardedAdWrapper(didRemoveFromRepository: ad)
     }
    
    private func removeAllAds(where condition: ((RewardedAdWrapper) -> Bool)? = nil){
        var ads:[RewardedAdWrapper] = []
        if let condition = condition {
            ads = adsRepo.filter(condition)
            adsRepo.removeAll(where:condition)
        }else{
            ads = adsRepo
            adsRepo.removeAll()
        }
        ads.forEach({$0.delegate?.rewardedAdWrapper(didRemoveFromRepository: $0)})
    }
    
    public func validateRepositoryAds(){
        let ads = adsRepo.filter(notValidCondition)
        adsRepo.removeAll(where: notValidCondition)
        ads.forEach({$0.delegate?.rewardedAdWrapper(didRemoveFromRepository: $0)})
    }
    @discardableResult
    public func presentAd(vc:UIViewController,willLoad:((RewardedAdWrapper?)->Void)? = nil)->Bool{
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


extension RewardedAdRepository:RewardedAdOwnerDelegate{
    
    func adWrapper(didReady ad:RewardedAdWrapper) {
        errorHandler.restart()
        if let ad = adsRepo.first(where: {notValidCondition($0) && !$0.isPresenting}) {
            removeAd(ad: ad)
        }
        delegate?.rewardedAdRepository(didReceiveAds:self)
        AdsRepo.default.rewardedAdRepository(didReceiveAds:self)
        if !adsRepo.contains(where: {$0.state != .loaded}) && validAdCount == config.size{
            delegate?.rewardedAdRepository(didFinishLoading: self, error: nil)
            AdsRepo.default.rewardedAdRepository(didFinishLoading: self, error: nil)
        }
    }
    
    func adWrapper(didClose ad:RewardedAdWrapper) {
        if let ad = adsRepo.first(where: notValidCondition) {
            removeAd(ad: ad)
        }
    }
    
    func adWrapper(onError ad:RewardedAdWrapper, error: Error?) {
        removeAd(ad: ad)
        let isRetryAble = errorHandler.isRetryAble(error: error){[weak self] in
            self?.fillRepoAds()//add new ads but not load them
        }
        
        guard !isRetryAble  else{return}
        
        if  !adsRepo.contains(where: {$0.state != .error}){//if load all ads failed
            removeAllAds(where: {$0.state == .error})
            delegate?.rewardedAdRepository(didFinishLoading: self, error: error)
            AdsRepo.default.rewardedAdRepository(didFinishLoading: self, error: error)
        }
    }
    func adWrapper(didExpire ad: RewardedAdWrapper) {
        if autoFill {
            fillRepoAds()
        }
    }
}
