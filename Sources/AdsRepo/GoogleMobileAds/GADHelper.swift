//
//  GADHelper.swift
//  AdsRepo
//
//  Created by Ali on 7/22/22.
//

import Foundation
import GoogleMobileAds

#if SWIFT_PACKAGE
import AdsRepo
#endif


public typealias InterstitalAdRepository = GADAdRepository<GADInterstitialAdWrapper,InterstitialAdLoader>
public typealias RewardedAdRepository = GADAdRepository<GADRewardedAdWrapper,RewardedAdLoader>
public typealias NativeAdRepository = GADAdRepository<GADNativeAdWrapper,NativeAdLoader>

public func setTestDevices(deviceIds:[String]){
    GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = deviceIds
}
