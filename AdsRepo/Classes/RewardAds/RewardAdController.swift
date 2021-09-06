//
//  RewardAdController.swift
//  WidgetBox
//
//  Created by Ali on 9/1/21.
//

import Foundation
import GoogleMobileAds


class RewardAdsController:NSObject{
    
    static let `default` = RewardAdsController()
    var errorHandler = ErrorHandler()
    var adsRepo:[RewardAdWrapper] = []
    var repoConfig:RepoConfig?
    var isLoading:Bool {adsRepo.contains(where: {$0.isLoading})}
    var isDisable:Bool = false{
        didSet{
            if isDisable{
                adsRepo.removeAll()
            }
        }
    }
    var isConfig:Bool{return repoConfig != nil}
    var delegate:AdsRepoDelegate? = nil
    
    init(delegate:AdsRepoDelegate? = nil){
        self.delegate = delegate
    }
  func fillRepoAds(){
        guard !isDisable else{return}
        guard let repoConfig = repoConfig else {return}
        let loadingAdsCount = adsRepo.filter({$0.isLoading}).count
        let totalAdsNeedCount = repoConfig.repoSize-loadingAdsCount
         for _ in adsRepo.count..<totalAdsNeedCount{
            adsRepo.append(RewardAdWrapper(repoConfig: repoConfig, delegate: self))
            adsRepo.last?.loadAd()
        }
    }
  func presentAd(vc:UIViewController){
        let now = Date().timeIntervalSince1970 * 1000
        guard let rewardedAdWrapper = adsRepo.min(by: {($0.loadedDate ?? now) < ($1.loadedDate ?? now)})
        else{return}
        rewardedAdWrapper.presentAd(vc: vc)
    }
    
    func hasReadyAd(vc:UIViewController)->Bool{
      return  adsRepo.first(where: {$0.adsIsReady(vc: vc)}) != nil
    }
    
}
extension RewardAdsController:RewardAdDelegate{
    func rewardAd(didReady ad:RewardAdWrapper) {
        delegate?.adMobManagerDelegate(didReady: ad)
        errorHandler.restart()
    }
    func rewardAd(didOpen ad:RewardAdWrapper) {
        delegate?.adMobManagerDelegate(didOpen: ad)
    }
    func rewardAd(willClose ad:RewardAdWrapper){
        delegate?.adMobManagerDelegate(willClose: ad)
    }
    func rewardAd(didClose ad:RewardAdWrapper) {
        delegate?.adMobManagerDelegate(didClose: ad)
        adsRepo.removeAll(where: {$0.showCount>0})
        fillRepoAds()
    }
    
    func rewardAd(onError ad:RewardAdWrapper, error: Error?) {
        delegate?.adMobManagerDelegate(onError: ad,error:error)
        adsRepo.removeAll(where: {$0 == ad})
        if errorHandler.isRetryAble(error: error),!isLoading{
            self.fillRepoAds()
        }
    }
    
    func rewardAd(didReward ad:RewardAdWrapper, reward: Double) {
        delegate?.adMobManagerDelegate(didReward: ad,reward:reward)
    }
    func rewardAd(didExpire ad: RewardAdWrapper) {
        delegate?.adMobManagerDelegate(didExpire: ad)
    }
    
    
}
