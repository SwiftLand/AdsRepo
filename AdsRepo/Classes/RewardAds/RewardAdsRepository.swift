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
    let identifier:String
    private var errorHandler:ErrorHandler
    public private(set) var adsRepo:[RewardedAdWrapper] = []
    public private(set) var config:RepoConfig
    public var isLoading:Bool {adsRepo.contains(where: {$0.isLoading})}
    public var autoFill:Bool = true
    public private(set) var isDisable:Bool = false{
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
    
    public init(identifier:String,config:RepoConfig,
                errorHandlerConfig:ErrorHandlerConfig? = nil,
                delegate:RewardedAdsRepositoryDelegate? = nil){
        
        self.identifier = identifier
        self.delegate = delegate
        self.config = config
        self.errorHandler = ErrorHandler(config: errorHandlerConfig)
        super.init()
    }
    public func fillRepoAds(){
        guard !isDisable else{return}
        let loadingAdsCount = adsRepo.filter({$0.isLoading}).count
        let totalAdsNeedCount = config.repoSize-loadingAdsCount
        while adsRepo.count<totalAdsNeedCount{
            adsRepo.append(RewardedAdWrapper(owner: self))
            adsRepo.last?.loadAd()
        }
    }
    
    private func removeAd(ad: RewardedAdWrapper){//call when ad expire
           adsRepo.removeAll(where: {$0 == ad})
           ad.delegate?.rewardedAdWrapper(didRemoveFromRepository: ad)
     }
    
    public func validateRepositoryAds(){
        let now = Date().timeIntervalSince1970
        let condition:((RewardedAdWrapper) -> Bool) = {
            [unowned self] in
            (now-($0.loadedDate ?? now) > config.expireIntervalTime) || $0.showCount>=config.showCountThreshold
            
        }
        
        let ads = adsRepo.filter(condition)
        adsRepo.removeAll(where: condition)
        ads.forEach({$0.delegate?.rewardedAdWrapper(didRemoveFromRepository: $0)})
    }
    
    public func presentAd(vc:UIViewController,willLoad:((RewardedAdWrapper?)->Void)? = nil){
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
extension RewardedAdsRepository {
    static func == (lhs: RewardedAdsRepository, rhs: RewardedAdsRepository) -> Bool{
        lhs.identifier == rhs.identifier
    }
}
