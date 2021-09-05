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
    private(set) public var loadedDate:Date? = nil
    private(set) public var isLoading:Bool = false
    private(set) public var showCount:Int = 0
    
    var delegate:AdsRepoDelegate? = nil
    
    init(repoConfig:RepoConfig,delegate:AdsRepoDelegate? = nil) {
        self.delegate = delegate
        self.repoConfig = repoConfig
    }
    
    func loadAd(){
        let request = GADRequest()
        isLoading = true
        GADInterstitialAd.load(withAdUnitID:repoConfig.adUnitId,
                            request: request,completionHandler: { (ad, error) in
                            self.isLoading = false
                            if let error = error {
                                print("Rewarded ad failed to load with error: \(error.localizedDescription)")
                                self.delegate?.adMobManagerDelegate(onError:self,error:error)
                                return
                            }
                            self.loadedAd = ad
                            self.loadedDate = Date()
                            self.loadedAd?.fullScreenContentDelegate = self
                            self.delegate?.adMobManagerDelegate(didReady: self)
                           })
    }
    
    func presentAd(vc:UIViewController){
        
        if adsIsReady(vc: vc)  {
            loadedAd?.fullScreenContentDelegate = self
            loadedAd?.present(fromRootViewController: vc)
        } else {
            print("Ad wasn't ready")
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
}
extension InterstitialAdWrapper:GADFullScreenContentDelegate{
    public func adDidPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Rewarded ad presented.")
        showCount += 1
        delegate?.adMobManagerDelegate(didOpen: self)
    }
    /// Tells the delegate that the rewarded ad was dismissed.
    public func adWillDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Rewarded ad will dismiss.")
    }
    public func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Rewarded ad dismissed.")
        delegate?.adMobManagerDelegate(didClose: self)
    }
    /// Tells the delegate that the rewarded ad failed to present.
    public func ad(_ ad: GADFullScreenPresentingAd,
                     didFailToPresentFullScreenContentWithError error: Error) {
        print("Rewarded ad failed to present with error: \(error.localizedDescription).")
        delegate?.adMobManagerDelegate(onError: self,error:error)
    }
    
}
