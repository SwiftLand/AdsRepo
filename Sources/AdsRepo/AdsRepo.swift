//
//  AdRepo.swift
//  AdRepo
//
//  Created by Ali on 9/2/21.
//

import Foundation

public class AdsRepo:NSObject{
    public static let `default` = AdsRepo()
    var observers:[Weak<AdsRepoDelegate>] = []
    var repositories:[Weak<AdsRepoProtocol>] = []
    
    /// Disable all repositories
    public  var isDisable:Bool = false{
        didSet{
            repositories.removeAll(where: {$0.value == nil})
            repositories.forEach({$0.value?.isDisable = isDisable})
        }
    }
}

extension AdsRepo:AdsRepoDelegate{
    public func interstitialAdRepository(didReceive repo:InterstitialAdRepository){
        for ob in observers {
            ob.value?.interstitialAdRepository(didReceive: repo)
        }
    }
    public func interstitialAdRepository(didFinishLoading repo:InterstitialAdRepository,error:Error?){
        observers.removeAll(where: {$0.value == nil})
        for ob in observers {
            ob.value?.interstitialAdRepository(didFinishLoading: repo,error:error)
        }
    }
    
    public func rewardedAdRepository(didReceiveAds repo:RewardedAdRepository){
        observers.removeAll(where: {$0.value == nil})
        for ob in observers {
            ob.value?.rewardedAdRepository(didReceiveAds: repo)
        }
    }
    public func rewardedAdRepository(didFinishLoading repo:RewardedAdRepository,error:Error?){
        observers.removeAll(where: {$0.value == nil})
        for ob in observers {
            ob.value?.rewardedAdRepository(didFinishLoading: repo,error:error)
        }
    }
    
    public func nativeAdRepository(didReceive repo:NativeAdRepository){
        observers.removeAll(where: {$0.value == nil})
        for ob in observers {
            ob.value?.nativeAdRepository(didReceive: repo)
        }
    }
    public func nativeAdRepository(didFinishLoading repo:NativeAdRepository,error:Error?){
        observers.removeAll(where: {$0.value == nil})
        for ob in observers {
            ob.value?.nativeAdRepository(didFinishLoading: repo,error:error)
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
