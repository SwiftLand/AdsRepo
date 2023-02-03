//
//  GADHelper.swift
//  AdsRepo
//
//  Created by Ali on 7/22/22.
//

import Foundation
import GoogleMobileAds

public typealias InterstitalAdRepository = AdRepository<GADInterstitialAdWrapper,InterstitialAdLoader>
public typealias RewardedAdRepository = AdRepository<GADRewardedAdWrapper,RewardedAdLoader>
public typealias NativeAdRepository = AdRepository<GADNativeAdWrapper,NativeAdLoader>

public typealias InterstitialAd = GADInterstitialAdWrapper
public typealias RewardedAd = GADRewardedAdWrapper
public typealias NativeAd = GADNativeAdWrapper

public func setTestDevices(deviceIds:[String]){
    GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = deviceIds
}

