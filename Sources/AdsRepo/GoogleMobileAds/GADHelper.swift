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


public typealias GADInterstitalAdRepository = GADAdRepository<GADInterstitialAdWrapper,InterstitialAdLoader>
public typealias GADRewardedAdRepository = GADAdRepository<GADRewardedAdWrapper,RewardedAdLoader>
public typealias GADNativeAdRepository = GADAdRepository<GADNativeAdWrapper,NativeAdLoader>

public func setTestDevices(deviceIds:[String]){
    GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = deviceIds
}
