//
//  RepositoryConfig.swift
//  AdsRepo
//
//  Created by Ali on 9/4/21.
//

import Foundation

/// `RepositoryConfig` contains all repository non-mutable configuration. it's necessary to create a repository
public struct RepositoryConfig{
    public let adUnitId:String
    public let size:Int
    public let expireIntervalTime:TimeInterval
    public let showCountThreshold:Int
    
    /// Init non-mutable `RepositoryConfig` struct
    /// - Parameters:
    ///   - adUnitId: Unit Id that's google provided
    ///   - size: Repository total size
    ///   - expireIntervalTime: Expire time for each repository ad
    ///   - showCountThreshold: Max number that the repository can load each ad
    public init(
        adUnitId:String,//unitId that's google provided
        size:Int,//repository total size
        expireIntervalTime:TimeInterval = 10,//reopo in second
        showCountThreshold:Int = 1//max time can show an ad
    ) {
            self.adUnitId = adUnitId
            self.size = size
            self.showCountThreshold = showCountThreshold
            self.expireIntervalTime = expireIntervalTime
        }
    
    public static let App_Open_ID =   "ca-app-pub-3940256099942544/5662855259"
    public static let Banner_ID  = "ca-app-pub-3940256099942544/2934735716"
    public static let Interstitial_ID =   "ca-app-pub-3940256099942544/4411468910"
    public static let Interstitial_Video_ID   = "ca-app-pub-3940256099942544/5135589807"
    public static let Rewarded_ID  =  "ca-app-pub-3940256099942544/1712485313"
    public static let Rewarded_Interstitial_ID  = "ca-app-pub-3940256099942544/6978759866"
    public static let Native_Advanced_ID   = "ca-app-pub-3940256099942544/3986624511"
    public static let Native_Advanced_Video_ID = "ca-app-pub-3940256099942544/2521693316"
    
    public static func debugInterstitialConfig(size:Int = 2) -> RepositoryConfig {
        RepositoryConfig(
            adUnitId:RepositoryConfig.Interstitial_ID,
            size: size,
            showCountThreshold: 1
        )
    }
    public static func debugInterstitialVideoConfig(size:Int = 2) -> RepositoryConfig {
        RepositoryConfig(
            adUnitId: RepositoryConfig.Interstitial_Video_ID,
            size: size,
            showCountThreshold: 1
        )
    }
    public  static func debugRewardedConfig(size:Int = 2) -> RepositoryConfig {
        RepositoryConfig(
            adUnitId: RepositoryConfig.Rewarded_ID,
            size: size,
            showCountThreshold: 1
        )
    }
    public static func debugRewardedInterstitialConfig(size:Int = 2) -> RepositoryConfig {
        RepositoryConfig(
            adUnitId: RepositoryConfig.Rewarded_Interstitial_ID,
            size: size,
            showCountThreshold: 1
        )
    }
    public static func debugNativeVideoConfig(size:Int = 2) -> RepositoryConfig {
        RepositoryConfig(
            adUnitId:RepositoryConfig.Native_Advanced_Video_ID,
            size: size,
            showCountThreshold: 3
        )
    }
    public static func debugNativeConfig(size:Int = 2) -> RepositoryConfig {
        RepositoryConfig(
            adUnitId: RepositoryConfig.Native_Advanced_ID,
            size: size,
            showCountThreshold: 3
        )
    }
}

