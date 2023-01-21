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
    let interstitialAdsRepo: AdRepository<InterstitialAdWrapper> = {
       return AdRepository<InterstitialAdWrapper>(config:RepositoryConfig.debugInterstitialConfig())
    }()
    let rewardedAdsRepo: AdRepository<RewardedAdWrapper> = {
        return AdRepository<RewardedAdWrapper>(config:RepositoryConfig.debugRewardedConfig())
    }()

    let nativeVideoAdRepo: AdRepository<NativeAdWrapper> = {
       return AdRepository<NativeAdWrapper>(config:RepositoryConfig.debugNativeVideoConfig())
    }()
    let nativeAdRepo: AdRepository<NativeAdWrapper> = {
        return AdRepository<NativeAdWrapper>(config:RepositoryConfig.debugNativeConfig())
    }()

    
    func fillAllRepositories(){
//        interstitialAdsRepo.fillRepoAds()
//        rewardedAdsRepo.fillRepoAds()
//        nativeVideoAdRepo.fillRepoAds()
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

