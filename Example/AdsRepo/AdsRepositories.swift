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
    
    let interstitialAdsRepo: InterstitalAdRepository = {
        let repo = InterstitalAdRepository(config:AdRepositoryConfig.debugInterstitialConfig())
        repo.waitForNewAdBeforeRemove = false
       return repo
    }()
    let rewardedAdsRepo: RewardedAdRepository = {
        let repo = RewardedAdRepository(config:AdRepositoryConfig.debugRewardedConfig())
        repo.waitForNewAdBeforeRemove = false
        return repo
    }()

    let nativeVideoAdRepo: NativeAdRepository = {
        let repo = NativeAdRepository(config:AdRepositoryConfig.debugNativeVideoConfig())
        let videoOptions = GADVideoOptions()
          videoOptions.customControlsRequested = true
        repo.adLoader.set(options: [videoOptions])
        repo.adLoader.set(adTypes: [.native])
       return repo
    }()
    
    let nativeAdRepo: NativeAdRepository = {
        return NativeAdRepository(config:AdRepositoryConfig.debugNativeConfig())
    }()
    
    func fillAllRepositories(){
        interstitialAdsRepo.fillRepoAds()
        rewardedAdsRepo.fillRepoAds()
        nativeVideoAdRepo.fillRepoAds()
        nativeAdRepo.fillRepoAds()
    }
    
    func add(Observer ob:AdRepositoryDelegate){
        interstitialAdsRepo.append(delegate: ob)
        rewardedAdsRepo.append(delegate: ob)
        nativeVideoAdRepo.append(delegate: ob)
        nativeAdRepo.append(delegate: ob)
    }
    func remove(Observer ob:AdRepositoryDelegate){
        interstitialAdsRepo.remove(delegate: ob)
        rewardedAdsRepo.remove(delegate: ob)
        nativeVideoAdRepo.remove(delegate: ob)
        nativeAdRepo.remove(delegate: ob)
    }
}
