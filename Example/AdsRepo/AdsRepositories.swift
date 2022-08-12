//
//  AdsRepositories.swift
//  AdsRepo_Example
//
//  Created by Ali on 7/23/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import AdsRepo
import GoogleMobileAds

class RepositoryManager{
    static let shared = RepositoryManager()
    let interstitialAdsRepo: InterstitialAdRepository = {
       return InterstitialAdRepository(config:RepositoryConfig.debugInterstitialConfig())
    }()
    let rewardedAdsRepo: RewardedAdRepository = {
        return RewardedAdRepository(config:RepositoryConfig.debugRewardedConfig())
    }()

    let nativeVideoAdRepo: NativeAdRepository = {
       return NativeAdRepository(config:RepositoryConfig.debugNativeVideoConfig())
    }()
    let nativeAdRepo: NativeAdRepository = {
        return NativeAdRepository(config:RepositoryConfig.debugNativeConfig())
    }()

    
    func fillAllRepositories(){
        interstitialAdsRepo.fillRepoAds()
        rewardedAdsRepo.fillRepoAds()
        nativeVideoAdRepo.fillRepoAds()
        nativeAdRepo.fillRepoAds()
    }
}

