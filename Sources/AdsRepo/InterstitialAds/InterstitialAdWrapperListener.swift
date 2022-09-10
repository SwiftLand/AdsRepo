//
//  InterstitialAdWrapperListener.swift
//  AdsRepo
//
//  Created by Ali on 8/29/22.
//

import Foundation
import GoogleMobileAds

internal class InterstitialAdWrapperListener:NSObject,GADFullScreenContentDelegate{
    weak var owner:InterstitialAdWrapper?
    private(set) var isPresenting:Bool = false
    init(owner:InterstitialAdWrapper) {
        self.owner = owner
    }
    func adDidRecordClick(_ ad: GADFullScreenPresentingAd) {
        guard let owner = owner else {return}
        owner.loadedAd?._fullScreenContentDelegate?.adDidRecordClick?(ad)
        owner.delegate?.interstitialAdWrapper(didRecordClick: owner)
    }
    func adDidRecordImpression(_ ad: GADFullScreenPresentingAd) {
        guard let owner = owner else {return}
        owner.loadedAd?._fullScreenContentDelegate?.adDidRecordImpression?(ad)
        owner.delegate?.interstitialAdWrapper(didRecordImpression: owner)
    }

    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Interstitial Ad  presented.")
        isPresenting = true
        guard let owner = owner else {return}
        owner.loadedAd?._fullScreenContentDelegate?.adWillPresentFullScreenContent?(ad)
        owner.delegate?.interstitialAdWrapper(willOpen:  owner)
    }
    /// Tells the delegate that the rewarded ad was dismissed.
    func adWillDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Interstitial Ad  will dismiss.")
        isPresenting = true
        guard let owner = owner else {return}
        owner.loadedAd?._fullScreenContentDelegate?.adWillDismissFullScreenContent?(ad)
        owner.delegate?.interstitialAdWrapper(willClose: owner)
    }
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Interstitial Ad did dismissed.")
        isPresenting = false
        guard let owner = owner else {return}
        owner.loadedAd?._fullScreenContentDelegate?.adDidDismissFullScreenContent?(ad)
        owner.delegate?.interstitialAdWrapper(didClose: owner)
        owner.ownerDelegate?.adWrapper(didClose: owner)
    }
    /// Tells the delegate that the rewarded ad failed to present.
    func ad(_ ad: GADFullScreenPresentingAd,
            didFailToPresentFullScreenContentWithError error: Error) {
        print("Interstitial Ad  failed to present with error: \(error.localizedDescription).")
        isPresenting = false
        guard let owner = owner else {return}
        owner.loadedAd?._fullScreenContentDelegate?.ad?(ad,didFailToPresentFullScreenContentWithError: error)
        owner.delegate?.interstitialAdWrapper(onError: owner,error:error)
    }
}
