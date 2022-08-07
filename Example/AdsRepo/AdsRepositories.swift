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
    let interstitialAdsRepo: InterstitialAdsRepository = {
       return InterstitialAdsRepository(identifier: "InterstitialAdsRepository",
                                                     config:RepoConfig.debugInterstitialConfig())
    }()
    let rewardedAdsRepo: RewardedAdsRepository = {
        return RewardedAdsRepository(identifier: "RewardedAdsRepository",
                                                 config:RepoConfig.debugRewardedConfig())
    }()

    let nativeVideoAdRepo: NativeAdsRepository = {
       return NativeAdsRepository(identifier: "nativeVideoAdRepository",
                                               config:RepoConfig.debugNativeVideoConfig())
    }()
    let nativeAdRepo: NativeAdsRepository = {
        return NativeAdsRepository(identifier: "nativeImageAdRepository",
                                   config:RepoConfig.debugNativeConfig())
    }()

    
    func fillAllRepositories(){
        interstitialAdsRepo.fillRepoAds()
        rewardedAdsRepo.fillRepoAds()
        nativeVideoAdRepo.fillRepoAds()
        nativeAdRepo.fillRepoAds()
    }
}

