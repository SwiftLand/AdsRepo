//
//  AdCreator.swift
//  AdsRepo-Unit-Tests
//
//  Created by Ali on 8/10/22.
//

import Foundation
import GoogleMobileAds
protocol ADCreatorProtocol{
    func createAd(owner:InterstitialAdRepository)->InterstitialAdWrapper
    func createAd(owner:RewardedAdRepository)->RewardedAdWrapper
    func createAd(loadedAd: GADNativeAd,owner: NativeAdRepository)->NativeAdWrapper
}

class ADCreator:ADCreatorProtocol{
    func createAd(owner: RewardedAdRepository) -> RewardedAdWrapper {
        return RewardedAdWrapper(owner: owner)
    }
    
    func createAd(loadedAd: GADNativeAd,owner: NativeAdRepository) -> NativeAdWrapper {
        return NativeAdWrapper(loadedAd: loadedAd,owner: owner)
    }
    
    func createAd(owner:InterstitialAdRepository)->InterstitialAdWrapper{
        return InterstitialAdWrapper(owner: owner)
    }
}
