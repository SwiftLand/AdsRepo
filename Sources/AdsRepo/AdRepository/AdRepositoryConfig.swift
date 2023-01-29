//
//  RepositoryConfig.swift
//  AdsRepo
//
//  Created by Ali on 9/4/21.
//

import Foundation

/// `RepositoryConfig` contains all repository non-mutable configuration. it's necessary to create a repository
public struct AdRepositoryConfig{
    public let adUnitId:String
    public let size:Int
    public var expireIntervalTime:TimeInterval = 120//in second
    public var showCountThreshold:Int = 1
    
    /// Init non-mutable `RepositoryConfig` struct
    /// - Parameters:
    ///   - adUnitId: Unit Id that's google provided
    ///   - size: Repository total size
    ///   - expireIntervalTime: Expire time for each repository ad
    ///   - showCountThreshold: Max number that the repository can load each ad

    
    public static let GAD_App_Open_ID =   "ca-app-pub-3940256099942544/5662855259"
    public static let GAD_Banner_ID  = "ca-app-pub-3940256099942544/2934735716"
    public static let GAD_Interstitial_ID =   "ca-app-pub-3940256099942544/4411468910"
    public static let GAD_Interstitial_Video_ID   = "ca-app-pub-3940256099942544/5135589807"
    public static let GAD_Rewarded_ID  =  "ca-app-pub-3940256099942544/1712485313"
    public static let GAD_Rewarded_Interstitial_ID  = "ca-app-pub-3940256099942544/6978759866"
    public static let GAD_Native_Advanced_ID   = "ca-app-pub-3940256099942544/3986624511"
    public static let GAD_Native_Advanced_Video_ID = "ca-app-pub-3940256099942544/2521693316"
    
    public static func debugInterstitialConfig(size:Int = 2) -> AdRepositoryConfig {
        AdRepositoryConfig(
            adUnitId:AdRepositoryConfig.GAD_Interstitial_ID,
            size: size,
            showCountThreshold: 1
        )
    }
    public static func debugInterstitialVideoConfig(size:Int = 2) -> AdRepositoryConfig {
        AdRepositoryConfig(
            adUnitId: AdRepositoryConfig.GAD_Interstitial_Video_ID,
            size: size,
            showCountThreshold: 1
        )
    }
    public  static func debugRewardedConfig(size:Int = 2) -> AdRepositoryConfig {
        AdRepositoryConfig(
            adUnitId: AdRepositoryConfig.GAD_Rewarded_ID,
            size: size,
            showCountThreshold: 1
        )
    }
    public static func debugRewardedInterstitialConfig(size:Int = 2) -> AdRepositoryConfig {
        AdRepositoryConfig(
            adUnitId: AdRepositoryConfig.GAD_Rewarded_Interstitial_ID,
            size: size,
            showCountThreshold: 1
        )
    }
    public static func debugNativeVideoConfig(size:Int = 2) -> AdRepositoryConfig {
        AdRepositoryConfig(
            adUnitId:AdRepositoryConfig.GAD_Native_Advanced_Video_ID,
            size: size,
            showCountThreshold: 3
        )
    }
    public static func debugNativeConfig(size:Int = 2) -> AdRepositoryConfig {
        AdRepositoryConfig(
            adUnitId: AdRepositoryConfig.GAD_Native_Advanced_ID,
            size: size,
            showCountThreshold: 3
        )
    }
}

