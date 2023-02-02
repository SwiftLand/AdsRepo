//
//  AdWrapperProtocol.swift
//  AdsRepo
//
//  Created by Ali on 9/23/22.
//

import Foundation

public typealias InterstitialAd = GADInterstitialAdWrapper
public typealias RewardedAd = GADRewardedAdWrapper
public typealias NativeAd = GADNativeAdWrapper

public protocol AdWrapperProtocol:NSObject{
    
    associatedtype AdType:NSObject
    
    /// Repository configuration. See **AdRepositoryConfig.swift** for more details.
    var config:AdRepositoryConfig{get}
    
    /// Unique id for the ad wrapper that used for some process in the ad's own repository
    var uniqueId:String{get}
    
    /// Any ad type object (ex: GADNativeAd)
    var loadedAd:AdType{get}
    
    /// Ad's  loaded Date
    var loadedDate:Date{get}
    
    /// Show how many time this object return as valid ads to user. See **loadAd** function in **AdRepository.swift** for more details
    /// - NOTE: This value typically changes by the ad's own repository but you can also change it if failed to show/present returned ad.
    var showCount:Int{get set}
}
