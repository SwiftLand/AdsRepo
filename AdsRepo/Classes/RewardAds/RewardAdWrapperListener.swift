//
//  RewardAdWrapperListener.swift
//  AdsRepo
//
//  Created by Ali on 8/29/22.
//

import Foundation
import GoogleMobileAds

internal class RewardAdWrapperListener:NSObject,GADFullScreenContentDelegate{
    weak var owner:RewardedAdWrapper?
    private(set) var isPresenting:Bool = false
    init(owner:RewardedAdWrapper) {
        self.owner = owner
    }
    func adDidRecordClick(_ ad: GADFullScreenPresentingAd) {
        guard let owner = owner else {return}
        owner.loadedAd?._fullScreenContentDelegate?.adDidRecordClick?(ad)
        owner.delegate?.rewardedAdWrapper(didRecordClick: owner)
    }
    func adDidRecordImpression(_ ad: GADFullScreenPresentingAd) {
        guard let owner = owner else {return}
        owner.loadedAd?._fullScreenContentDelegate?.adDidRecordImpression?(ad)
        owner.delegate?.rewardedAdWrapper(didRecordImpression: owner)
    }
    func adDidPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Rewarded ad presented.")
        isPresenting = true
        guard let owner = owner else {return}
        owner.loadedAd?._fullScreenContentDelegate?.adDidPresentFullScreenContent?(ad)
        owner.delegate?.rewardedAdWrapper(didOpen:  owner)
    }
    /// Tells the delegate that the rewarded ad was dismissed.
    func adWillDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Rewarded ad will dismiss.")
        isPresenting = true
        guard let owner = owner else {return}
        owner.loadedAd?._fullScreenContentDelegate?.adWillDismissFullScreenContent?(ad)
        owner.delegate?.rewardedAdWrapper(willClose: owner)
    }
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Rewarded ad dismissed.")
        isPresenting = false
        guard let owner = owner else {return}
        owner.loadedAd?._fullScreenContentDelegate?.adDidDismissFullScreenContent?(ad)
        owner.delegate?.rewardedAdWrapper(didClose: owner)
        owner.ownerDelegate?.adWrapper(didClose: owner)
    }
    /// Tells the delegate that the rewarded ad failed to present.
    func ad(_ ad: GADFullScreenPresentingAd,
            didFailToPresentFullScreenContentWithError error: Error) {
        print("Rewarded Ad  failed to present with error: \(error.localizedDescription).")
        isPresenting = false
        guard let owner = owner else {return}
        owner.loadedAd?._fullScreenContentDelegate?.ad?(ad,didFailToPresentFullScreenContentWithError: error)
        owner.delegate?.rewardedAdWrapper(onError: owner,error:error)
    }
}
