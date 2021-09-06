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
    private(set) var errorHandler = ErrorHandler()
    var isLoading:Bool {adsRepo.contains(where: {$0.isLoading})}
    private(set) var adsRepo:[InterstitialAdWrapper] = []
    var repoConfig:RepoConfig? = nil
    var isConfig:Bool{return repoConfig != nil}
    var isDisable:Bool = false{
        didSet{
            if isDisable{
                adsRepo.removeAll()
            }
        }
    }
    var delegate:AdsRepoDelegate? = nil
    
    init(delegate:AdsRepoDelegate? = nil){
        super.init()
        self.delegate = delegate
    }
    func fillRepoAds(){
         guard !isDisable else{return}
         guard let repoConfig = repoConfig else {return}
          let loadingAdsCount = adsRepo.filter({$0.isLoading}).count
          let totalAdsNeedCount = repoConfig.repoSize-loadingAdsCount
          for _ in adsRepo.count..<totalAdsNeedCount{
            adsRepo.append(InterstitialAdWrapper(repoConfig: repoConfig, delegate: self))
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
    
extension InterstitialAdsController:InterstitialAdDelegate{

    func interstitialAd(didReady ad:InterstitialAdWrapper) {
        delegate?.adMobManagerDelegate(didReady: ad)
        errorHandler.restart()
    }
    
    func interstitialAd(didOpen ad:InterstitialAdWrapper) {
        delegate?.adMobManagerDelegate(didOpen: ad)
    }
    func interstitialAd(willClose ad:InterstitialAdWrapper){
        delegate?.adMobManagerDelegate(willClose: ad)
    }
    func interstitialAd(didClose ad:InterstitialAdWrapper) {
        delegate?.adMobManagerDelegate(didClose: ad)
        adsRepo.removeAll(where: {$0.showCount>0})
        fillRepoAds()
    }
    
    func interstitialAd(onError ad:InterstitialAdWrapper, error: Error?) {
        delegate?.adMobManagerDelegate(onError: ad,error:error)
        adsRepo.removeAll(where: {$0 == ad})
        if errorHandler.isRetryAble(error: error),!isLoading{
            fillRepoAds()
        }
    }
    func interstitialAd(didExpire ad: InterstitialAdWrapper) {
        adsRepo.removeAll(where: {$0 == ad})
        fillRepoAds()
    }
}

