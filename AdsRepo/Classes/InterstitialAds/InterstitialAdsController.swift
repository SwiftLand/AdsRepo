//
//  InterstitialAdContoller.swift
//  WidgetBox
//
//  Created by ali khajehpour on 10/27/20.
//

import Foundation
import GoogleMobileAds
class InterstitialAdsController:NSObject {
    static let `default` = InterstitialAdsController()
    var adsRepo:[InterstitialAdWrapper] = []
    var repoConfig:RepoConfig? = nil
    var isConfig:Bool{return repoConfig != nil}
    var isDisable:Bool = false
    var delegate:AdsRepoDelegate? = nil
    
    init(delegate:AdsRepoDelegate? = nil){
        super.init()
        self.delegate = delegate
    }
    func fillRepoAds(){
         guard !isDisable else{return}
         guard let repoConfig = repoConfig else {return}
          let showedCount = adsRepo.filter({$0.showCount == 0}).count
          for _ in adsRepo.count..<repoConfig.totalSize + showedCount{
            adsRepo.append(InterstitialAdWrapper(repoConfig: repoConfig, delegate: self))
              adsRepo.last?.loadAd()
          }
      }

  func presentAd(vc:UIViewController){
        adsRepo.sort(by: {($0.loadedDate ?? Date()) < ($1.loadedDate ?? Date())})
        guard let rewardedAdWrapper = adsRepo.first else{
            return
        }
        rewardedAdWrapper.presentAd(vc: vc)
    }
    
    func hasReadyAd(vc:UIViewController)->Bool{
      return  adsRepo.first(where: {$0.adsIsReady(vc: vc)}) != nil
    }

}
    
extension InterstitialAdsController:AdsRepoDelegate{

    func adMobManagerDelegate(didReady ad:InterstitialAdWrapper) {
        delegate?.adMobManagerDelegate(didReady: ad)
    }
    
    func adMobManagerDelegate(didOpen ad:InterstitialAdWrapper) {
        delegate?.adMobManagerDelegate(didOpen: ad)
            fillRepoAds()
    }
    func adMobManagerDelegate(willClose ad:InterstitialAdWrapper){
        delegate?.adMobManagerDelegate(willClose: ad)
    }
    func adMobManagerDelegate(didClose ad:InterstitialAdWrapper) {
        delegate?.adMobManagerDelegate(didClose: ad)
        adsRepo.removeAll(where: {$0.showCount>0})
    }
    
    func adMobManagerDelegate(onError ad:InterstitialAdWrapper, error: Error?) {
        delegate?.adMobManagerDelegate(onError: ad,error:error)
        adsRepo.removeAll(where: {$0 == ad})
        fillRepoAds()
    }
}

