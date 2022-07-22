//
//  AdMobManager.swift
//  AdMobManager
//
//  Created by Ali on 9/2/21.
//

import Foundation
protocol AdsRepoProtocol {
    
}
public class AdsRepo:NSObject{
    public static let `default` = AdsRepo()
    var observers:[Weak<AdsRepoObserver>] = []
}

extension AdsRepo:AdsRepoDelegate{
    
    public func nativeAdsControl(didReceive config:RepoConfig){
        for ob in observers {
            ob.value?.nativeAdsControl(didReceive: config)
        }
    }
    
    public func nativeAdsControl(didFinishLoading config:RepoConfig,error:Error?){
        for ob in observers {
            ob.value?.nativeAdsControl(didFinishLoading: config,error:error)
        }
    }
    
    public func rewardedAdsController(didReceiveAds config:RepoConfig){
        for ob in observers {
            ob.value?.rewardedAdsController(didReceiveAds: config)
        }
    }
    public func rewardedAdsController(didFinishLoading config:RepoConfig,error:Error?){
        for ob in observers {
            ob.value?.rewardedAdsController(didFinishLoading: config,error:error)
        }
    }
    
    public func interstitialAdsController(didReceive config:RepoConfig){
        for ob in observers {
            ob.value?.interstitialAdsController(didReceive: config)
        }
    }
    public func interstitialAdsController(didFinishLoading config:RepoConfig,error:Error?){
        for ob in observers {
            ob.value?.interstitialAdsController(didFinishLoading: config,error:error)
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
