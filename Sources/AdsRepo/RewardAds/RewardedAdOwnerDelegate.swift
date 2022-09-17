//
//  RewardedAdOwnerDelegate.swift
//  AdsRepo
//
//  Created by Ali on 8/29/22.
//

import Foundation

/// Protocol to communicate `RewardedAdWrapper` with its own repository
internal protocol RewardedAdOwnerDelegate:NSObject{
    func adWrapper(didReady ad:RewardedAdWrapper)
    func adWrapper(didClose ad:RewardedAdWrapper)
    func adWrapper(onError ad:RewardedAdWrapper, error: Error?)
    func adWrapper(didExpire ad: RewardedAdWrapper)
}
