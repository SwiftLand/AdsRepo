//
//  BannerController.swift
//  AdsRepo
//
//  Created by Ali on 10/13/21.
//

import Foundation



protocol BannerAdDelegate {
    func bannerAd(didReady ad:BannerAdWrapper)
    func bannerAd(didShown ad:BannerAdWrapper)
    func bannerAd(willDismiss ad:BannerAdWrapper)
    func bannerAd(didDismiss ad:BannerAdWrapper)
    func bannerAd(onError ad:BannerAdWrapper,error:Error?)
    func bannerAd(didExpire ad:BannerAdWrapper)
}
protocol BannerAdsControllerDelegate:BannerAdDelegate {
    func didReceiveBannerAds()
    func didFinishLoadingBannerAds()
    func didFailToReceiveBannerAdWithError(_ error: Error)
}
class BannerAdsController:NSObject{
    static let `default` = BannerAdsController()
    private(set) var errorHandler = ErrorHandler()
    var isLoading:Bool {adsRepo.contains(where: {$0.isLoading})}
    private(set) var adsRepo:[BannerAdWrapper] = []
    private weak var rootVC:UIViewController? = nil
    var repoConfig:RepoConfig? = nil
    var isConfig:Bool{return repoConfig != nil}
    var isDisable:Bool = false{
        didSet{
            if isDisable{
                adsRepo.removeAll()
            }else{
                fillRepoAds()
            }
        }
    }
    var isFull:Bool{
        adsRepo.count >= (repoConfig?.repoSize ?? 0)
    }
    var delegate:BannerAdsControllerDelegate? = nil
    
    init(delegate:BannerAdsControllerDelegate? = nil){
        super.init()
        self.delegate = delegate
    }
    
    func config(_ config:RepoConfig? = nil,rootVC:UIViewController? = nil){
        self.rootVC = rootVC
        self.repoConfig = config
    }
    func fillRepoAds(){
         guard !isDisable else{return}
         guard let rootVC  = rootVC else {return}
          guard let repoConfig = repoConfig else {return}
          let loadingAdsCount = adsRepo.filter({$0.isLoading}).count
          let totalAdsNeedCount = repoConfig.repoSize-loadingAdsCount
          while adsRepo.count<totalAdsNeedCount{
            adsRepo.append(BannerAdWrapper(repoConfig: repoConfig, owner: self))
              adsRepo.last?.loadAd(rootVC: rootVC)
          }
      }

    func loadAd(onAdReay:@escaping ((BannerAdWrapper?)->Void)){
        guard let repoConfig = repoConfig else {return}
        
        let now = Date().timeIntervalSince1970
        adsRepo.removeAll(where: {now-($0.loadedDate ?? now) > repoConfig.expireIntervalTime})
        
        guard adsRepo.count > 0 else {
            onAdReay(nil)
            fillRepoAds()
            return
        }
        
        if let lessShowCount = adsRepo.min(by: {$0.showCount<$1.showCount}) {
            onAdReay(lessShowCount)
        }
        
        if adsRepo.count<repoConfig.repoSize {
            fillRepoAds()
        }
    }
    
    func hasReadyAd(vc:UIViewController)->Bool{
      return  adsRepo.first(where: {$0.isReady}) != nil
    }

}
extension BannerAdsController:BannerAdDelegate{
    func bannerAd(didReady ad: BannerAdWrapper) {
        delegate?.bannerAd(didReady: ad)
        delegate?.didReceiveBannerAds()
        if isFull {
            delegate?.didFinishLoadingBannerAds()
        }
        errorHandler.restart()
    }
    
    func bannerAd(didShown ad: BannerAdWrapper) {
        delegate?.bannerAd(didShown: ad)
    }
    
    func bannerAd(willDismiss ad: BannerAdWrapper) {
        delegate?.bannerAd(willDismiss: ad)
    }
    
    func bannerAd(didDismiss ad: BannerAdWrapper) {
        delegate?.bannerAd(didDismiss: ad)
        if let threshold = repoConfig?.showCountThreshold,ad.showCount>=threshold{
            adsRepo.removeAll(where: {$0 == ad})
            fillRepoAds()
        }
    }
    
    func bannerAd(onError ad: BannerAdWrapper, error: Error?) {
        delegate?.bannerAd(onError: ad,error:error)
        adsRepo.removeAll(where: {$0 == ad})
        if errorHandler.isRetryAble(error: error),!isLoading{
            fillRepoAds()
        }
    }
    
    func bannerAd(didExpire ad: BannerAdWrapper) {
        delegate?.bannerAd(didExpire: ad)
        adsRepo.removeAll(where: {$0 == ad})
        fillRepoAds()
    }
    
 
    
    
}
