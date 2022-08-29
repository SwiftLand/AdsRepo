//
//  RewardedAdWrapperDelegate.swift
//  AdsRepo
//
//  Created by Ali on 8/29/22.
//

import Foundation

public protocol RewardedAdWrapperDelegate:NSObject {
    func rewardedAdWrapper(didReady ad:RewardedAdWrapper)
    func rewardedAdWrapper(didOpen ad:RewardedAdWrapper)
    func rewardedAdWrapper(didRecordClick ad:RewardedAdWrapper)
    func rewardedAdWrapper(didRecordImpression ad:RewardedAdWrapper)
    func rewardedAdWrapper(willClose ad:RewardedAdWrapper)
    func rewardedAdWrapper(didClose ad:RewardedAdWrapper)
    func rewardedAdWrapper(didShowCountChanged ad:RewardedAdWrapper)
    func rewardedAdWrapper(didRemoveFromRepository ad:RewardedAdWrapper)
    func rewardedAdWrapper(onError ad:RewardedAdWrapper,error:Error?)
    func rewardedAdWrapper(didReward ad:RewardedAdWrapper,reward:Double)
    func rewardedAdWrapper(didExpire ad:RewardedAdWrapper)
}
extension RewardedAdWrapperDelegate {
    public func rewardedAdWrapper(didReady ad:RewardedAdWrapper){}
    public func rewardedAdWrapper(didOpen ad:RewardedAdWrapper){}
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
