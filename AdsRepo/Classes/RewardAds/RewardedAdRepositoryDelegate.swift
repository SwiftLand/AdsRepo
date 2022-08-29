//
//  RewardedAdRepositoryDelegate.swift
//  AdsRepo
//
//  Created by Ali on 8/29/22.
//

import Foundation
public protocol RewardedAdRepositoryDelegate:NSObject {
    func rewardedAdRepository(didReceiveAds repo:RewardedAdRepository)
    func rewardedAdRepository(didFinishLoading repo:RewardedAdRepository,error:Error?)
}

extension RewardedAdRepositoryDelegate {
    public func rewardedAdRepository(didReceiveAds repo:RewardedAdRepository){}
    public func rewardedAdRepository(didFinishLoading repo:RewardedAdRepository,error:Error?){}
}
