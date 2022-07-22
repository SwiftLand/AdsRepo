//
//  RewardAdController.swift
//  WidgetBox
//
//  Created by Ali on 9/1/21.
//

import Foundation
import GoogleMobileAds

public protocol RewardedAdsControllerDelegate:NSObject {
    func rewardedAdsController(didReceiveAds config:RepoConfig)
    func rewardedAdsController(didFinishLoading config:RepoConfig,error:Error?)
}

extension RewardedAdsControllerDelegate {
    func rewardedAdsController(didReceiveAds config:RepoConfig){}
    func rewardedAdsController(didFinishLoading config:RepoConfig,error:Error?){}
}

public class RewardedAdsController:NSObject,AdsRepoProtocol{

    private var errorHandler:ErrorHandler
    var adsRepo:[RewardAdWrapper] = []
    var config:RepoConfig
    var isLoading:Bool {adsRepo.contains(where: {$0.isLoading})}
    var isDisable:Bool = false{
        didSet{
            if isDisable{
                errorHandler.cancel()
                adsRepo.removeAll()
            }else{
                fillRepoAds()
            }
        }
    }
   weak var delegate:RewardedAdsControllerDelegate? = nil
    
    init(config:RepoConfig,
         errorHandlerConfig:ErrorHandlerConfig? = nil,
         delegate:RewardedAdsControllerDelegate? = nil){
        self.delegate = delegate
        self.config = config
        self.errorHandler = ErrorHandler(config: errorHandlerConfig)
        super.init()
    }
    func fillRepoAds(){
        guard !isDisable else{return}
        let loadingAdsCount = adsRepo.filter({$0.isLoading}).count
        let totalAdsNeedCount = config.repoSize-loadingAdsCount
        while adsRepo.count<totalAdsNeedCount{
            adsRepo.append(RewardAdWrapper(owner: self))
            adsRepo.last?.loadAd()
        }
    }
    
    func presentAd(vc:UIViewController){
        let now = Date().timeIntervalSince1970
        guard let rewardedAdWrapper = adsRepo.min(by: {($0.loadedDate ?? now) < ($1.loadedDate ?? now)})
        else{return}
        rewardedAdWrapper.presentAd(vc: vc)
    }
    
    func hasReadyAd(vc:UIViewController)->Bool{
        return  adsRepo.first(where: {$0.isReady(vc: vc)}) != nil
    }
    
}
extension RewardedAdsController{
    
    func rewardAd(didReady ad:RewardAdWrapper) {
        errorHandler.restart()
        delegate?.rewardedAdsController(didReceiveAds:config)
        AdsRepo.default.rewardedAdsController(didReceiveAds:config)
        if !adsRepo.contains(where: {!$0.isLoaded}){
            delegate?.rewardedAdsController(didFinishLoading: config, error: nil)
            AdsRepo.default.rewardedAdsController(didFinishLoading: config, error: nil)
        }
    }
    
    func rewardAd(didClose ad:RewardAdWrapper) {
        adsRepo.removeAll(where: {$0.showCount>0})
        fillRepoAds()
    }
    
    func rewardAd(onError ad:RewardAdWrapper, error: Error?) {
        adsRepo.removeAll(where: {$0 == ad})
        if errorHandler.isRetryAble(error: error),!isLoading{
            self.fillRepoAds()
        }else{
            delegate?.rewardedAdsController(didFinishLoading: config, error: error)
            AdsRepo.default.rewardedAdsController(didFinishLoading: config, error: error)
        }
    }
    func rewardAd(didExpire ad: RewardAdWrapper) {
        adsRepo.removeAll(where: {$0 == ad})
        fillRepoAds()
    }
}
