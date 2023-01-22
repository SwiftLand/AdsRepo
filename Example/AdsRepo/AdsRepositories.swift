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
    let interstitialAdsRepo: AdRepository<InterstitialAd> = {
       return AdRepository<InterstitialAd>(config:AdRepositoryConfig.debugInterstitialConfig())
    }()
    let rewardedAdsRepo: AdRepository<RewardedAd> = {
        return AdRepository<RewardedAd>(config:AdRepositoryConfig.debugRewardedConfig())
    }()

    let nativeVideoAdRepo: AdRepository<NativeAd> = {
       return AdRepository<NativeAd>(config:AdRepositoryConfig.debugNativeVideoConfig())
    }()
    let nativeAdRepo: AdRepository<NativeAd> = {
        return AdRepository<NativeAd>(config:AdRepositoryConfig.debugNativeConfig())
    }()

    
    func fillAllRepositories(){
        interstitialAdsRepo.fillRepoAds()
        rewardedAdsRepo.fillRepoAds()
        nativeVideoAdRepo.fillRepoAds()
        nativeAdRepo.fillRepoAds()
    }
    
    func add(Observer ob:AdRepositoryDelegate){
        interstitialAdsRepo.append(observer: ob)
        rewardedAdsRepo.append(observer: ob)
        nativeVideoAdRepo.append(observer: ob)
        nativeAdRepo.append(observer: ob)
    }
    func remove(Observer ob:AdRepositoryDelegate){
        interstitialAdsRepo.remove(observer: ob)
        rewardedAdsRepo.remove(observer: ob)
        nativeVideoAdRepo.remove(observer: ob)
        nativeAdRepo.remove(observer: ob)
    }
}

