//
//  RepositoryConfig.swift
//  AdsRepo
//
//  Created by Ali on 9/4/21.
//

import Foundation

public struct RepositoryConfig{
    
    public let adUnitId:String
    public let size:Int
    public let expireIntervalTime:TimeInterval
    public let showCountThreshold:Int
    public let isTaggedForChildDirectedTreatment: Bool?// COPPA
    public let isTaggedForUnderAgeOfConsent: Bool // GDPR
    public let isUMPDisabled: Bool?// Disables User Messaging Platform (UMP) SDK
     
   public init(
        adUnitId:String,
        size:Int,
        expireIntervalTime:TimeInterval = 120,//second
        showCountThreshold:Int = 1,
        isTaggedForChildDirectedTreatment: Bool?  = nil ,
        isTaggedForUnderAgeOfConsent: Bool = false,
        isUMPDisabled: Bool? = nil ) {
        
        self.adUnitId = adUnitId
        self.size = size
        self.showCountThreshold = showCountThreshold
        self.expireIntervalTime = expireIntervalTime
        self.isTaggedForChildDirectedTreatment = isTaggedForChildDirectedTreatment
        self.isTaggedForUnderAgeOfConsent = isTaggedForUnderAgeOfConsent
        self.isUMPDisabled = isUMPDisabled
    }
    
    public static let App_Open_ID =   "ca-app-pub-3940256099942544/5662855259"
    public static let Banner_ID  = "ca-app-pub-3940256099942544/2934735716"
    public static let Interstitial_ID =   "ca-app-pub-3940256099942544/4411468910"
    public static let Interstitial_Video_ID   = "ca-app-pub-3940256099942544/5135589807"
    public static let Rewarded_ID  =  "ca-app-pub-3940256099942544/1712485313"
    public static let Rewarded_Interstitial_ID  = "ca-app-pub-3940256099942544/6978759866"
    public static let Native_Advanced_ID   = "ca-app-pub-3940256099942544/3986624511"
    public static let Native_Advanced_Video_ID = "ca-app-pub-3940256099942544/2521693316"
    
    public static func debugInterstitialConfig(isUMPDisabled: Bool = false,size:Int = 2) -> RepositoryConfig {
        RepositoryConfig(
            adUnitId:RepositoryConfig.Interstitial_ID,
            size: size,
            showCountThreshold: 1,
            isTaggedForChildDirectedTreatment: nil,
            isTaggedForUnderAgeOfConsent: false,
            isUMPDisabled: isUMPDisabled
        )
    }
    public static func debugInterstitialVideoConfig(isUMPDisabled: Bool = false,size:Int = 2) -> RepositoryConfig {
        RepositoryConfig(
            adUnitId: RepositoryConfig.Interstitial_Video_ID,
            size: size,
            showCountThreshold: 1,
            isTaggedForChildDirectedTreatment: nil,
            isTaggedForUnderAgeOfConsent: false,
            isUMPDisabled: isUMPDisabled
        )
    }
    public  static func debugRewardedConfig(isUMPDisabled: Bool = false,size:Int = 2) -> RepositoryConfig {
        RepositoryConfig(
            adUnitId: RepositoryConfig.Rewarded_ID,
            size: size,
            showCountThreshold: 1,
            isTaggedForChildDirectedTreatment: nil,
            isTaggedForUnderAgeOfConsent: false,
            isUMPDisabled: isUMPDisabled
        )
    }
    public static func debugRewardedInterstitialConfig(isUMPDisabled: Bool = false,size:Int = 2) -> RepositoryConfig {
        RepositoryConfig(
            adUnitId: RepositoryConfig.Rewarded_Interstitial_ID,
            size: size,
            showCountThreshold: 1,
            isTaggedForChildDirectedTreatment: nil,
            isTaggedForUnderAgeOfConsent: false,
            isUMPDisabled: isUMPDisabled
        )
    }
    public static func debugNativeVideoConfig(isUMPDisabled: Bool = false,size:Int = 2) -> RepositoryConfig {
        RepositoryConfig(
            adUnitId:RepositoryConfig.Native_Advanced_Video_ID,
            size: size,
            showCountThreshold: 3,
            isTaggedForChildDirectedTreatment: nil,
            isTaggedForUnderAgeOfConsent: false,
            isUMPDisabled: isUMPDisabled
        )
    }
    public static func debugNativeConfig(isUMPDisabled: Bool = false,size:Int = 2) -> RepositoryConfig {
        RepositoryConfig(
            adUnitId: RepositoryConfig.Native_Advanced_ID,
            size: size,
            showCountThreshold: 3,
            isTaggedForChildDirectedTreatment: nil,
            isTaggedForUnderAgeOfConsent: false,
            isUMPDisabled: isUMPDisabled
        )
    }
}

