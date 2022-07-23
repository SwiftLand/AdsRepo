//
//  AdMobManager.swift
//  AdMobManager
//
//  Created by Ali on 9/2/21.
//

import Foundation

protocol AdsRepoProtocol {}

public class AdsRepo:NSObject{
    public static let `default` = AdsRepo()
    var observers:[Weak<AdsRepoObserver>] = []
}

extension AdsRepo:AdsRepoDelegate{
    public func interstitialAdsController(didReceive repo:InterstitialAdsController){
        for ob in observers {
            ob.value?.interstitialAdsController(didReceive: repo)
        }
    }
    public func interstitialAdsController(didFinishLoading repo:InterstitialAdsController,error:Error?){
        for ob in observers {
            ob.value?.interstitialAdsController(didFinishLoading: repo,error:error)
        }
    }
    
    public func rewardedAdsController(didReceiveAds repo:RewardedAdsController){
        for ob in observers {
            ob.value?.rewardedAdsController(didReceiveAds: repo)
        }
    }
    public func rewardedAdsController(didFinishLoading repo:RewardedAdsController,error:Error?){
        for ob in observers {
            ob.value?.rewardedAdsController(didFinishLoading: repo,error:error)
        }
    }
    
    public func nativeAdsControl(didReceive repo:NativeAdsController){
        for ob in observers {
            ob.value?.nativeAdsControl(didReceive: repo)
        }
    }
    public func nativeAdsControl(didFinishLoading repo:NativeAdsController,error:Error?){
        for ob in observers {
            ob.value?.nativeAdsControl(didFinishLoading: repo,error:error)
        }
    }
}

extension AdsRepo:AdsRepoObservable{
    
    public func addObserver(observer: AdsRepoObserver) {
        observers.append(Weak(observer))
    }
    
    public func removeObserver(observer: AdsRepoObserver) {
        observers.removeAll(where: {$0.value?.observerId  == observer.observerId})
    }
    
    public func removeObserver(observerId: String) {
        observers.removeAll(where: {$0.value?.observerId == observerId})
    }
}
