//
//  RepoConfig.swift
//  AdsRepo
//
//  Created by Ali on 9/4/21.
//

import Foundation

public typealias AdSize = (width:Double,height:Double)

public struct RepoConfig{
    
     let adUnitId:String
     let repoSize:Int
     let expireIntervalTime:TimeInterval
     let showCountThreshold:Int?
     let isTaggedForChildDirectedTreatment: Bool?// COPPA
     let isTaggedForUnderAgeOfConsent: Bool // GDPR
     let isUMPDisabled: Bool?// Disables User Messaging Platform (UMP) SDK
     let bannerSize:AdSize?
    
   public init(
        adUnitId:String,
        repoSize:Int,
        expireIntervalTime:TimeInterval = 360000,
        showCountThreshold:Int? = nil,
        bannerSize:AdSize? = nil,
        isTaggedForChildDirectedTreatment: Bool?  = nil ,
        isTaggedForUnderAgeOfConsent: Bool = false,
        isUMPDisabled: Bool? = nil ) {
        
        self.adUnitId = adUnitId
        self.repoSize = repoSize
        self.showCountThreshold = showCountThreshold
        self.bannerSize = bannerSize
        self.expireIntervalTime = expireIntervalTime
        self.isTaggedForChildDirectedTreatment = isTaggedForChildDirectedTreatment
        self.isTaggedForUnderAgeOfConsent = isTaggedForUnderAgeOfConsent
        self.isUMPDisabled = isUMPDisabled
    }
    static func debugBanngerConfig(isUMPDisabled: Bool) -> RepoConfig {
        RepoConfig(
            adUnitId: "ca-app-pub-3940256099942544/2934735716", repoSize: 2,
            isTaggedForChildDirectedTreatment: nil,
            isTaggedForUnderAgeOfConsent: false,
            isUMPDisabled: isUMPDisabled
        )
    }
    static func debugInterstitialConfig(isUMPDisabled: Bool) -> RepoConfig {
        RepoConfig(
            adUnitId: "ca-app-pub-3940256099942544/4411468910", repoSize: 2,
            isTaggedForChildDirectedTreatment: nil,
            isTaggedForUnderAgeOfConsent: false,
            isUMPDisabled: isUMPDisabled
        )
    }
    static func debugRewardedConfig(isUMPDisabled: Bool) -> RepoConfig {
        RepoConfig(
            adUnitId: "ca-app-pub-3940256099942544/1712485313",repoSize: 2,
            isTaggedForChildDirectedTreatment: nil,
            isTaggedForUnderAgeOfConsent: false,
            isUMPDisabled: isUMPDisabled
        )
    }
    static func debugRewardedInterstitialConfig(isUMPDisabled: Bool) -> RepoConfig {
        RepoConfig(
            adUnitId: "ca-app-pub-3940256099942544/6978759866",repoSize: 2,
            isTaggedForChildDirectedTreatment: nil,
            isTaggedForUnderAgeOfConsent: false,
            isUMPDisabled: isUMPDisabled
        )
    }
    static func debugNativeConfig(isUMPDisabled: Bool) -> RepoConfig {
        RepoConfig(
            adUnitId: "ca-app-pub-3940256099942544/3986624511",repoSize: 5,
            isTaggedForChildDirectedTreatment: nil,
            isTaggedForUnderAgeOfConsent: false,
            isUMPDisabled: isUMPDisabled
        )
    }
}

