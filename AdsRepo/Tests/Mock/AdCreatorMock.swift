//
//  AdCreatorMock.swift
//  AdsRepo-Unit-Tests
//
//  Created by Ali on 8/10/22.
//

import Foundation
import GoogleMobileAds
@testable import AdsRepo

class AdCreatorMock:ADCreatorProtocol{
    var interstitialAdMocks:[InterstitialAdWrapperDelegateMock] = []
    var rewardedAdMocks:[RewardedAdWrapperDelegateMock] = []
    var nativeAdMocks:[RewardedAdWrapperDelegateMock] = []
    
    func createAd(owner: InterstitialAdsRepository) -> InterstitialAdWrapper {
        let ad = InterstitialAdWrapper(owner: owner)
        ad.adLoader = FakeInterstitialAdMock.self
        let mock = InterstitialAdWrapperDelegateMock()
        ad.delegate = mock
        interstitialAdMocks.append(mock)
        return ad
    }
    
    func createAd(owner: RewardedAdsRepository) -> RewardedAdWrapper {
        let ad = RewardedAdWrapper(owner: owner)
        ad.adLoader = FakeRewardedAdMock.self
        let mock = RewardedAdWrapperDelegateMock()
        ad.delegate = mock
        rewardedAdMocks.append(mock)
        return ad
    }
    
    func createAd(loadedAd: GADNativeAd,owner: NativeAdsRepository) -> NativeAdWrapper {
        let ad = NativeAdWrapper(loadedAd: loadedAd,owner: owner)
        return ad
    }
    
    func clearMocks(){
        interstitialAdMocks.removeAll()
    }
    
}
