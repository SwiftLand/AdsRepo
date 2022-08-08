//
//  AdRepo.swift
//  AdRepo
//
//  Created by Ali on 9/2/21.
//

import Foundation

protocol AdsRepoProtocol {}

public class AdsRepo:NSObject{
    public static let `default` = AdsRepo()
    var observers:[Weak<AdsRepoDelegate>] = []
}

extension AdsRepo:AdsRepoDelegate{
    public func interstitialAdsRepository(didReceive repo:InterstitialAdsRepository){
        for ob in observers {
            ob.value?.interstitialAdsRepository(didReceive: repo)
        }
    }
    public func interstitialAdsRepository(didFinishLoading repo:InterstitialAdsRepository,error:Error?){
        for ob in observers {
            ob.value?.interstitialAdsRepository(didFinishLoading: repo,error:error)
        }
    }
    
    public func rewardedAdsRepository(didReceiveAds repo:RewardedAdsRepository){
        for ob in observers {
            ob.value?.rewardedAdsRepository(didReceiveAds: repo)
        }
    }
    public func rewardedAdsRepository(didFinishLoading repo:RewardedAdsRepository,error:Error?){
        for ob in observers {
            ob.value?.rewardedAdsRepository(didFinishLoading: repo,error:error)
        }
    }
    
    public func nativeAdsRepository(didReceive repo:NativeAdsRepository){
        for ob in observers {
            ob.value?.nativeAdsRepository(didReceive: repo)
        }
    }
    public func nativeAdsRepository(didFinishLoading repo:NativeAdsRepository,error:Error?){
        for ob in observers {
            ob.value?.nativeAdsRepository(didFinishLoading: repo,error:error)
        }
    }
}

extension AdsRepo:AdsRepoObservable{
    
    public func addObserver(observer: AdsRepoDelegate) {
        observers.append(Weak(observer))
    }
    
    public func removeObserver(observer: AdsRepoDelegate) {
        observers.removeAll(where: {$0.value  === observer})
    }
}
