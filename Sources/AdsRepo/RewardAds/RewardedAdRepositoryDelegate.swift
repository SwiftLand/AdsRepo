//
//  RewardedAdRepositoryDelegate.swift
//  AdsRepo
//
//  Created by Ali on 8/29/22.
//

import Foundation
public protocol RewardedAdRepositoryDelegate:NSObject {
    ///Will call after each ad receives
    /// - Parameter repo: current native Ad repository
    func rewardedAdRepository(didReceiveAds repo:RewardedAdRepository)
    ///Will call after repository fill or can't handle error any more.
    /// - Parameters:
    ///   - repo: Current native Ad repository
    ///   - error: Final error after retries base on error handler object. see **ErrorHandler.swift** for more details
    func rewardedAdRepository(didFinishLoading repo:RewardedAdRepository,error:Error?)
}

extension RewardedAdRepositoryDelegate {
    public func rewardedAdRepository(didReceiveAds repo:RewardedAdRepository){}
    public func rewardedAdRepository(didFinishLoading repo:RewardedAdRepository,error:Error?){}
}
