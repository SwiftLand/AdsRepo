//
//  BannerWrapper.swift
//  AdsRepo
//
//  Created by Ali on 10/13/21.
//

import Foundation
import GoogleMobileAds

public class BannerAdWrapper:NSObject{
    public private(set) var repoConfig:RepoConfig
    public private(set) var loadedAd: GADBannerView?
    public private(set) var loadedDate:TimeInterval? = nil
    public private(set) var isLoading:Bool = false
    public private(set) var isLoaded:Bool = false
    public private(set) var showCount:Int = 0
    public var isReady:Bool {
        return loadedAd != nil && isLoaded
    }
    private var timer:Timer? = nil
    private weak var owner:BannerAdsController? = nil
    
    init(repoConfig:RepoConfig,owner:BannerAdsController? = nil) {
        self.owner = owner
        self.repoConfig = repoConfig
    }
    func loadAd(rootVC:UIViewController){
        guard let size = repoConfig.bannerSize else {return}
        guard !isLoading else {return}
        isLoading = true
        let adSize = GADInlineAdaptiveBannerAdSizeWithWidthAndMaxHeight(size.width, size.height)
        loadedAd = GADBannerView(adSize: adSize)
        loadedAd?.rootViewController = rootVC
        loadedAd?.adUnitID = repoConfig.adUnitId
        loadedAd?.delegate = self
        loadedAd?.load(GADRequest())
    }
    private func stopTime(){
        timer?.invalidate()
        timer = nil
    }
   
    deinit {
        stopTime()
        print("deinit","Interstitial AdWrapper")
    }
}
extension BannerAdWrapper:GADBannerViewDelegate{
    public func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        self.loadedDate = Date().timeIntervalSince1970
        self.timer = Timer.scheduledTimer(withTimeInterval: self.repoConfig.expireIntervalTime,
                                          repeats: false, block: {[weak self] timer in
            print("banner Ad was expire")
            guard let self = self else {return}
            self.owner?.bannerAd(didExpire: self)
        })
        self.owner?.bannerAd(didReady: self)
        self.isLoaded = true
    }

    public func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
      print("bannerView:didFailToReceiveAdWithError: \(error.localizedDescription)")
      self.owner?.bannerAd(onError:self,error:error)
    }

    public func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
      print("bannerViewDidRecordImpression")
    }

    public func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
      print("bannerViewWillPresentScreen")
       showCount += 1
       owner?.bannerAd(didShown: self)
    }

    public func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
      print("bannerViewWillDIsmissScreen")
        owner?.bannerAd(willDismiss: self)
    }

    public func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
      print("bannerViewDidDismissScreen")
        owner?.bannerAd(didDismiss: self)
    }
}
