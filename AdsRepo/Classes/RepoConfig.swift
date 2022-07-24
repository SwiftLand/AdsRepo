//
//  RepoConfig.swift
//  AdsRepo
//
//  Created by Ali on 9/4/21.
//

import Foundation

public struct RepoConfig{
    
    public let adUnitId:String
    public let repoSize:Int
    public let expireIntervalTime:TimeInterval
    public let showCountThreshold:Int
    public let isTaggedForChildDirectedTreatment: Bool?// COPPA
    public let isTaggedForUnderAgeOfConsent: Bool // GDPR
    public let isUMPDisabled: Bool?// Disables User Messaging Platform (UMP) SDK
     
   public init(
        adUnitId:String,
        repoSize:Int,
        expireIntervalTime:TimeInterval = 120,//second
        showCountThreshold:Int = 1,
        isTaggedForChildDirectedTreatment: Bool?  = nil ,
        isTaggedForUnderAgeOfConsent: Bool = false,
        isUMPDisabled: Bool? = nil ) {
        
        self.adUnitId = adUnitId
        self.repoSize = repoSize
        self.showCountThreshold = showCountThreshold
        self.expireIntervalTime = expireIntervalTime
        self.isTaggedForChildDirectedTreatment = isTaggedForChildDirectedTreatment
        self.isTaggedForUnderAgeOfConsent = isTaggedForUnderAgeOfConsent
        self.isUMPDisabled = isUMPDisabled
    }
    
    public static func debugInterstitialConfig(isUMPDisabled: Bool = false,size:Int = 2) -> RepoConfig {
        RepoConfig(
            adUnitId: "ca-app-pub-3940256099942544/4411468910",
            repoSize: size,
            showCountThreshold: 1,
            isTaggedForChildDirectedTreatment: nil,
            isTaggedForUnderAgeOfConsent: false,
            isUMPDisabled: isUMPDisabled
        )
    }
    public static func debugInterstitialVideoConfig(isUMPDisabled: Bool = false,size:Int = 2) -> RepoConfig {
        RepoConfig(
            adUnitId: "ca-app-pub-3940256099942544/5135589807",
            repoSize: size,
            showCountThreshold: 1,
            isTaggedForChildDirectedTreatment: nil,
            isTaggedForUnderAgeOfConsent: false,
            isUMPDisabled: isUMPDisabled
        )
    }
    public  static func debugRewardedConfig(isUMPDisabled: Bool = false,size:Int = 2) -> RepoConfig {
        RepoConfig(
            adUnitId: "ca-app-pub-3940256099942544/1712485313",
            repoSize: size,
            showCountThreshold: 1,
            isTaggedForChildDirectedTreatment: nil,
            isTaggedForUnderAgeOfConsent: false,
            isUMPDisabled: isUMPDisabled
        )
    }
    public static func debugRewardedInterstitialConfig(isUMPDisabled: Bool = false,size:Int = 2) -> RepoConfig {
        RepoConfig(
            adUnitId: "ca-app-pub-3940256099942544/6978759866",
            repoSize: size,
            showCountThreshold: 1,
            isTaggedForChildDirectedTreatment: nil,
            isTaggedForUnderAgeOfConsent: false,
            isUMPDisabled: isUMPDisabled
        )
    }
    public static func debugNativeVideoConfig(isUMPDisabled: Bool = false,size:Int = 2) -> RepoConfig {
        RepoConfig(
            adUnitId: "ca-app-pub-3940256099942544/2521693316",
            repoSize: size,
            showCountThreshold: 3,
            isTaggedForChildDirectedTreatment: nil,
            isTaggedForUnderAgeOfConsent: false,
            isUMPDisabled: isUMPDisabled
        )
    }
    public static func debugNativeConfig(isUMPDisabled: Bool = false,size:Int = 2) -> RepoConfig {
        RepoConfig(
            adUnitId: "ca-app-pub-3940256099942544/3986624511",
            repoSize: size,
            showCountThreshold: 3,
            isTaggedForChildDirectedTreatment: nil,
            isTaggedForUnderAgeOfConsent: false,
            isUMPDisabled: isUMPDisabled
        )
    }
}

