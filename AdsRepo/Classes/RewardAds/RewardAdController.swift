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
    
    var adsRepo:[RewardAdWrapper] = []
    var repoConfig:RepoConfig?
    var isDisable:Bool = false
    var isConfig:Bool{return repoConfig != nil}
    var delegate:AdsRepoDelegate? = nil
    
    init(delegate:AdsRepoDelegate? = nil){
        self.delegate = delegate
    }
  func fillRepoAds(){
       guard !isDisable else{return}
        guard let repoConfig = repoConfig else {return}
        let showedCount = adsRepo.filter({$0.showCount == 0}).count
         for _ in adsRepo.count..<repoConfig.totalSize+showedCount{
            adsRepo.append(RewardAdWrapper(repoConfig: repoConfig, delegate: self))
            adsRepo.last?.loadAd()
        }
    }
  func presentAd(vc:UIViewController){
      
        guard let rewardedAdWrapper = adsRepo.first else{
            return
        }
        rewardedAdWrapper.presentAd(vc: vc)
    }
    
    func hasReadyAd(vc:UIViewController)->Bool{
      return  adsRepo.first(where: {$0.adsIsReady(vc: vc)}) != nil
    }
    
}
extension RewardAdsController:AdsRepoDelegate{
    func adMobManagerDelegate(didReady ad:RewardAdWrapper) {
        delegate?.adMobManagerDelegate(didReady: ad)
    }
    
    func adMobManagerDelegate(didOpen ad:RewardAdWrapper) {
        delegate?.adMobManagerDelegate(didOpen: ad)
        fillRepoAds()
    }
    func adMobManagerDelegate(willClose ad:RewardAdWrapper){
        delegate?.adMobManagerDelegate(willClose: ad)
    }
    func adMobManagerDelegate(didClose ad:RewardAdWrapper) {
        delegate?.adMobManagerDelegate(didClose: ad)
        adsRepo.removeAll(where: {$0.showCount>0})
    }
    
    func adMobManagerDelegate(onError ad:RewardAdWrapper, error: Error?) {
        delegate?.adMobManagerDelegate(onError: ad,error:error)
        adsRepo.removeAll(where: {$0 == ad})
        fillRepoAds()
        
    }
    
    func adMobManagerDelegate(didReward ad:RewardAdWrapper, reward: Double) {
        delegate?.adMobManagerDelegate(didReward: ad,reward:reward)
    }
    
    
}
