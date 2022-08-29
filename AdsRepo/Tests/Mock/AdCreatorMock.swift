//
//  AdCreatorMock.swift
//  AdsRepo-Unit-Tests
//
//  Created by Ali on 8/10/22.
//

import Foundation
import GoogleMobileAds
@testable import AdsRepo

class AdCreatorMock:AdCreatorProtocol{
    var interstitialAdMocks:[InterstitialAdWrapperDelegateMock] = []
    var rewardedAdMocks:[RewardedAdWrapperDelegateMock] = []
    var nativeAdMocks:[NativeAdWrapperDelegateMock] = []
    
    var responseError:NSError? = nil
    
    func createAd(owner: InterstitialAdRepository) -> InterstitialAdWrapper {
        let ad = InterstitialAdWrapper(owner: owner)
        ad.adLoader = FakeInterstitialAdMock.self
        FakeInterstitialAdMock.error = responseError
        let mock = InterstitialAdWrapperDelegateMock()
        ad.delegate = mock
        interstitialAdMocks.append(mock)
        return ad
    }
    
    func createAd(owner: RewardedAdRepository) -> RewardedAdWrapper {
        let ad = RewardedAdWrapper(owner: owner)
        ad.adLoader = FakeRewardedAdMock.self
        FakeRewardedAdMock.error = responseError
        let mock = RewardedAdWrapperDelegateMock()
        ad.delegate = mock
        rewardedAdMocks.append(mock)
        return ad
    }
    
    func createAd(loadedAd: GADNativeAd,owner: NativeAdRepository) -> NativeAdWrapper {
        let ad = NativeAdWrapper(loadedAd: loadedAd,owner: owner)
        let mock = NativeAdWrapperDelegateMock()
        ad.delegate = mock
        nativeAdMocks.append(mock)
        return ad
    }
    
    func clearMocks(){
        interstitialAdMocks.removeAll()
        rewardedAdMocks.removeAll()
        nativeAdMocks.removeAll()
    }
    
}
