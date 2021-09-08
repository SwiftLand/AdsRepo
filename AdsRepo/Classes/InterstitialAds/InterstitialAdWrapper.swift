//
//  InterstitialAdWrapper.swift
//  AdMobManager
//
//  Created by Ali on 9/3/21.
//

import Foundation
import GoogleMobileAds


public class InterstitialAdWrapper:NSObject {
    
    
    private(set) public var repoConfig:RepoConfig
    private(set) public var loadedAd: GADInterstitialAd?
    private(set) public var loadedDate:TimeInterval? = nil
    private(set) public var isLoading:Bool = false
    private(set) public var showCount:Int = 0
    private var timer:Timer? = nil
    private weak var owner:InterstitialAdsController? = nil
    
    init(repoConfig:RepoConfig,owner:InterstitialAdsController? = nil) {
        self.owner = owner
        self.repoConfig = repoConfig
    }
    
    func loadAd(){
        guard !isLoading else {return}
        let request = GADRequest()
        isLoading = true
        GADInterstitialAd.load(withAdUnitID:repoConfig.adUnitId,
                               request: request,completionHandler: {[weak self] (ad, error) in
                                guard let self = self else{return}
                                self.isLoading = false
                                if let error = error {
                                    print("Interstitial Ad failed to load with error: \(error.localizedDescription)")
                                    self.owner?.interstitialAd(onError:self,error:error)
                                    return
                                }
                                self.loadedAd = ad
                                self.loadedDate = Date().timeIntervalSince1970
                                self.loadedAd?.fullScreenContentDelegate = self
                                self.owner?.interstitialAd(didReady: self)
                                self.timer = Timer.scheduledTimer(withTimeInterval: self.repoConfig.expireIntervalTime, repeats: false, block: {[weak self] timer in
                                    print("Interstitial Ad was expire")
                                    guard let self = self else {return}
                                    self.owner?.interstitialAd(didExpire: self)
                                })
                               })
    }

    func presentAd(vc:UIViewController){
        
        if adsIsReady(vc: vc)  {
            loadedAd?.fullScreenContentDelegate = self
            loadedAd?.present(fromRootViewController: vc)
        } else {
            print("Interstitial Ad  wasn't ready")
        }
    }
    
    func adsIsReady(vc:UIViewController)->Bool{
        guard loadedAd != nil else{return false}
        do{
            try self.loadedAd?.canPresent(fromRootViewController: vc)
            return true
        }catch{
            return false
        }
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
extension InterstitialAdWrapper:GADFullScreenContentDelegate{
    public func adDidPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Interstitial Ad  presented.")
        showCount += 1
        owner?.interstitialAd(didOpen: self)
    }
    /// Tells the delegate that the rewarded ad was dismissed.
    public func adWillDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Interstitial Ad  will dismiss.")
    }
    public func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Interstitial Ad  dismissed.")
        owner?.interstitialAd(didClose: self)
    }
    /// Tells the delegate that the rewarded ad failed to present.
    public func ad(_ ad: GADFullScreenPresentingAd,
                   didFailToPresentFullScreenContentWithError error: Error) {
        print("Interstitial Ad  failed to present with error: \(error.localizedDescription).")
        owner?.interstitialAd(onError: self,error:error)
    }
    
}
