//
//  AdCreator.swift
//  AdsRepo-Unit-Tests
//
//  Created by Ali on 8/10/22.
//

import Foundation
import GoogleMobileAds
protocol ADCreatorProtocol{
    func createAd(owner:InterstitialAdsRepository)->InterstitialAdWrapper
    func createAd(owner:RewardedAdsRepository)->RewardedAdWrapper
    func createAd(loadedAd: GADNativeAd,owner: NativeAdsRepository)->NativeAdWrapper
}

class ADCreator:ADCreatorProtocol{
    func createAd(owner: RewardedAdsRepository) -> RewardedAdWrapper {
        return RewardedAdWrapper(owner: owner)
    }
    
    func createAd(loadedAd: GADNativeAd,owner: NativeAdsRepository) -> NativeAdWrapper {
        return NativeAdWrapper(loadedAd: loadedAd,owner: owner)
    }
    
    func createAd(owner:InterstitialAdsRepository)->InterstitialAdWrapper{
        return InterstitialAdWrapper(owner: owner)
    }
}
