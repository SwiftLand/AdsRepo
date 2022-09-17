//
//  RewardedAdWrapperDelegate.swift
//  AdsRepo
//
//  Created by Ali on 8/29/22.
//

import Foundation

public protocol RewardedAdWrapperDelegate:NSObject {
    /// Will be called when the ad ready to show
    func rewardedAdWrapper(didReady ad:RewardedAdWrapper)
    
    /// Will be called when the ad will open full-screen
    func rewardedAdWrapper(willOpen ad:RewardedAdWrapper)
    
    /// Will be called when the ad record a click
    func rewardedAdWrapper(didRecordClick ad:RewardedAdWrapper)
    
    /// Will be called when the ad record a impression
    func rewardedAdWrapper(didRecordImpression ad:RewardedAdWrapper)
    
    /// Will be called when the ad become close
    func rewardedAdWrapper(willClose ad:RewardedAdWrapper)
    
    /// Will be called when the ad did close
    func rewardedAdWrapper(didClose ad:RewardedAdWrapper)
    
    /// Will be called when the `showCount` variable changes. It's will increase each time return ad with `presentAd` function inside **RewardedAdRepository.swift**.
    func rewardedAdWrapper(didShowCountChanged ad:RewardedAdWrapper)
    
    /// Will be called when an ad removed from its own repository
    func rewardedAdWrapper(didRemoveFromRepository ad:RewardedAdWrapper)
    
    /// Will be called when the ad received an error during load
    func rewardedAdWrapper(onError ad:RewardedAdWrapper,error:Error?)
    
    func rewardedAdWrapper(didReward ad:RewardedAdWrapper,reward:Double)
    
    ///Will be called when RewardedAdWrapper's timer finished. See `timer` inside **RewardedAdWrapper** for more details
    func rewardedAdWrapper(didExpire ad:RewardedAdWrapper)
}
extension RewardedAdWrapperDelegate {
    public func rewardedAdWrapper(didReady ad:RewardedAdWrapper){}
    public func rewardedAdWrapper(willOpen ad:RewardedAdWrapper){}
    public func rewardedAdWrapper(didRecordClick ad:RewardedAdWrapper){}
    public func rewardedAdWrapper(didRecordImpression ad:RewardedAdWrapper){}
    public func rewardedAdWrapper(willClose ad:RewardedAdWrapper){}
    public func rewardedAdWrapper(didClose ad:RewardedAdWrapper){}
    public func rewardedAdWrapper(didShowCountChanged ad:RewardedAdWrapper){}
    public func rewardedAdWrapper(didRemoveFromRepository ad:RewardedAdWrapper){}
    public func rewardedAdWrapper(onError ad:RewardedAdWrapper,error:Error?){}
    public func rewardedAdWrapper(didReward ad:RewardedAdWrapper,reward:Double){}
    public func rewardedAdWrapper(didExpire ad:RewardedAdWrapper){}
}
