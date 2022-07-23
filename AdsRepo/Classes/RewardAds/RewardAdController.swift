//
//  RewardAdController.swift
//  WidgetBox
//
//  Created by Ali on 9/1/21.
//

import Foundation
import GoogleMobileAds

public protocol RewardedAdsControllerDelegate:NSObject {
    func rewardedAdsController(didReceiveAds repo:RewardedAdsController)
    func rewardedAdsController(didFinishLoading repo:RewardedAdsController,error:Error?)
}

extension RewardedAdsControllerDelegate {
    public func rewardedAdsController(didReceiveAds repo:RewardedAdsController){}
    public func rewardedAdsController(didFinishLoading repo:RewardedAdsController,error:Error?){}
}

public class RewardedAdsController:NSObject,AdsRepoProtocol{

    private var errorHandler:ErrorHandler
    public private(set) var adsRepo:[RewardAdWrapper] = []
    public private(set) var config:RepoConfig
    public var isLoading:Bool {adsRepo.contains(where: {$0.isLoading})}
    public var autoFill:Bool = true
    public private(set) var isDisable:Bool = false{
        didSet{
            if isDisable{
                errorHandler.cancel()
                adsRepo.removeAll()
            }else{
                if autoFill {
                    fillRepoAds()
                }
            }
        }
    }
   weak var delegate:RewardedAdsControllerDelegate? = nil
    
 public init(config:RepoConfig,
         errorHandlerConfig:ErrorHandlerConfig? = nil,
         delegate:RewardedAdsControllerDelegate? = nil){
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
    
  public func presentAd(vc:UIViewController){
        let now = Date().timeIntervalSince1970
        guard let rewardedAdWrapper = adsRepo.min(by: {($0.loadedDate ?? now) < ($1.loadedDate ?? now)})
        else{return}
        rewardedAdWrapper.presentAd(vc: vc)
    }
    
    public func hasReadyAd(vc:UIViewController)->Bool{
        return  adsRepo.first(where: {$0.isReady(vc: vc)}) != nil
    }
    
}
extension RewardedAdsController{
    
    func rewardAd(didReady ad:RewardAdWrapper) {
        errorHandler.restart()
        delegate?.rewardedAdsController(didReceiveAds:self)
        AdsRepo.default.rewardedAdsController(didReceiveAds:self)
        if !adsRepo.contains(where: {!$0.isLoaded}){
            delegate?.rewardedAdsController(didFinishLoading: self, error: nil)
            AdsRepo.default.rewardedAdsController(didFinishLoading: self, error: nil)
        }
    }
    
    func rewardAd(didClose ad:RewardAdWrapper) {
        adsRepo.removeAll(where: {$0.showCount>0})
        if autoFill {
           fillRepoAds()
        }
    }
    
    func rewardAd(onError ad:RewardAdWrapper, error: Error?) {
        adsRepo.removeAll(where: {$0 == ad})
        if errorHandler.isRetryAble(error: error),!isLoading{
            if autoFill {
              self.fillRepoAds()
            }
        }else{
            delegate?.rewardedAdsController(didFinishLoading: self, error: error)
            AdsRepo.default.rewardedAdsController(didFinishLoading: self, error: error)
        }
    }
    func rewardAd(didExpire ad: RewardAdWrapper) {
        adsRepo.removeAll(where: {$0 == ad})
        if autoFill {
           fillRepoAds()
        }
    }
}
