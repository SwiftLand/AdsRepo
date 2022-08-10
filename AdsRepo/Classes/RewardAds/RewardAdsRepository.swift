//
//  RewardedAdsRepository.swift
//  AdRepo
//
//  Created by Ali on 9/1/21.
//

import Foundation
import GoogleMobileAds

public protocol RewardedAdsRepositoryDelegate:NSObject {
    func rewardedAdsRepository(didReceiveAds repo:RewardedAdsRepository)
    func rewardedAdsRepository(didFinishLoading repo:RewardedAdsRepository,error:Error?)
}

extension RewardedAdsRepositoryDelegate {
    public func rewardedAdsRepository(didReceiveAds repo:RewardedAdsRepository){}
    public func rewardedAdsRepository(didFinishLoading repo:RewardedAdsRepository,error:Error?){}
}

public class RewardedAdsRepository:NSObject,AdsRepoProtocol{
    
    internal var errorHandler:ErrorHandler = ErrorHandler()
    internal var adCreator:ADCreatorProtocol = ADCreator()
    
    public internal(set) var adsRepo:[RewardedAdWrapper] = []
    public private(set) var config:RepoConfig
    public var isLoading:Bool {adsRepo.contains(where: {$0.isLoading})}
    public var autoFill:Bool = true
    public var isDisable:Bool = false{
        didSet{
            if isDisable{
                errorHandler.cancel()
                let ads = adsRepo
                adsRepo.removeAll()
                ads.forEach({$0.delegate?.rewardedAdWrapper(didRemoveFromRepository: $0)})
            }else{
                if autoFill {
                    fillRepoAds()
                }
            }
        }
    }
    weak var delegate:RewardedAdsRepositoryDelegate? = nil
    
    let notValidCondition:((RewardedAdWrapper) -> Bool) = {
        return ($0.now-($0.loadedDate ?? $0.now) > $0.config.expireIntervalTime) || $0.showCount>=$0.config.showCountThreshold
    }
    
    public init(config:RepoConfig,
                errorHandlerConfig:ErrorHandlerConfig? = nil,
                delegate:RewardedAdsRepositoryDelegate? = nil){
        
        self.delegate = delegate
        self.config = config
        if let eConfig = errorHandlerConfig{
            self.errorHandler = ErrorHandler(config:eConfig)
        }
        super.init()
    }
    public func fillRepoAds(){
        guard !isDisable else{return}
        let loadingAdsCount = adsRepo.filter({$0.isLoading}).count
        let totalAdsNeedCount = config.repoSize-loadingAdsCount
        while adsRepo.count<totalAdsNeedCount{
            adsRepo.append(adCreator.createAd(owner: self))
            adsRepo.last?.loadAd()
        }
    }
    
    private func removeAd(ad: RewardedAdWrapper){//call when ad expire
           adsRepo.removeAll(where: {$0 == ad})
           ad.delegate?.rewardedAdWrapper(didRemoveFromRepository: ad)
     }
    
    public func validateRepositoryAds(){
        let ads = adsRepo.filter(notValidCondition)
        adsRepo.removeAll(where: notValidCondition)
        ads.forEach({$0.delegate?.rewardedAdWrapper(didRemoveFromRepository: $0)})
    }
    
    public func presentAd(vc:UIViewController,willLoad:((RewardedAdWrapper?)->Void)? = nil){
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
        return  adsRepo.first(where: {$0.isReady(vc: vc)}) != nil
    }
    
}
extension RewardedAdsRepository{//will call from RewardAdWrapper
    
    func rewardedAdWrapper(didReady ad:RewardedAdWrapper) {
        errorHandler.restart()
        delegate?.rewardedAdsRepository(didReceiveAds:self)
        AdsRepo.default.rewardedAdsRepository(didReceiveAds:self)
        if !adsRepo.contains(where: {!$0.isLoaded}){
            delegate?.rewardedAdsRepository(didFinishLoading: self, error: nil)
            AdsRepo.default.rewardedAdsRepository(didFinishLoading: self, error: nil)
        }
    }
    
    func rewardedAdWrapper(didClose ad:RewardedAdWrapper) {
        validateRepositoryAds()
        if autoFill {
            fillRepoAds()
        }
    }
    
    func rewardedAdWrapper(onError ad:RewardedAdWrapper, error: Error?) {
        removeAd(ad: ad)
        if errorHandler.isRetryAble(error: error),!isLoading{
            if autoFill {
                self.fillRepoAds()
            }
        }else{
            delegate?.rewardedAdsRepository(didFinishLoading: self, error: error)
            AdsRepo.default.rewardedAdsRepository(didFinishLoading: self, error: error)
        }
    }
    func rewardedAdWrapper(didExpire ad: RewardedAdWrapper) {
        removeAd(ad: ad)
        if autoFill {
            fillRepoAds()
        }
    }
}
