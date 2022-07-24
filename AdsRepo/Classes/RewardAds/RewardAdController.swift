//
//  RewardAdController.swift
//  WidgetBox
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
    public private(set) var adsRepo:[RewardAdWrapper] = []
    public private(set) var config:RepoConfig
    public var isLoading:Bool {adsRepo.contains(where: {$0.isLoading})}
    public var autoFill:Bool = true
    public private(set) var isDisable:Bool = false{
        didSet{
            if isDisable{
                errorHandler.cancel()
                adsRepo.forEach({$0.delegate?.rewardAd(didRemoveFromRepository: $0)})
                adsRepo.removeAll()
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
            adsRepo.append(RewardAdWrapper(owner: self))
            adsRepo.last?.loadAd()
        }
    }
    
    public func presentAd(vc:UIViewController,willLoad:((RewardAdWrapper)->Void)? = nil){
        let now = Date().timeIntervalSince1970
        guard let adWrapper = adsRepo.min(by: {($0.loadedDate ?? now) < ($1.loadedDate ?? now)})
        else{return}
        willLoad?(adWrapper)
        adWrapper.presentAd(vc: vc)
    }
    
    public func hasReadyAd(vc:UIViewController)->Bool{
        return  adsRepo.first(where: {$0.isReady(vc: vc)}) != nil
    }
    
}
extension RewardedAdsRepository{
    
    func rewardAd(didReady ad:RewardAdWrapper) {
        errorHandler.restart()
        delegate?.rewardedAdsRepository(didReceiveAds:self)
        AdsRepo.default.rewardedAdsRepository(didReceiveAds:self)
        if !adsRepo.contains(where: {!$0.isLoaded}){
            delegate?.rewardedAdsRepository(didFinishLoading: self, error: nil)
            AdsRepo.default.rewardedAdsRepository(didFinishLoading: self, error: nil)
        }
    }
    
    func rewardAd(didClose ad:RewardAdWrapper) {
        adsRepo.removeAll(where: {$0.showCount>=config.showCountThreshold})
        ad.delegate?.rewardAd(didRemoveFromRepository: ad)
        if autoFill {
           fillRepoAds()
        }
    }
    
    func rewardAd(onError ad:RewardAdWrapper, error: Error?) {
        adsRepo.removeAll(where: {$0 == ad})
        ad.delegate?.rewardAd(didRemoveFromRepository: ad)
        if errorHandler.isRetryAble(error: error),!isLoading{
            if autoFill {
              self.fillRepoAds()
            }
        }else{
            delegate?.rewardedAdsRepository(didFinishLoading: self, error: error)
            AdsRepo.default.rewardedAdsRepository(didFinishLoading: self, error: error)
        }
    }
    func rewardAd(didExpire ad: RewardAdWrapper) {
        adsRepo.removeAll(where: {$0 == ad})
        ad.delegate?.rewardAd(didRemoveFromRepository: ad)
        if autoFill {
           fillRepoAds()
        }
    }
}
