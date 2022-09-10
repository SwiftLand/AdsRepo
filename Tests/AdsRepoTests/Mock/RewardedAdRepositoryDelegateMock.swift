//
//  RewardedAdsRepositoryDelegateMock.swift
//  AdsRepo-Unit-Tests
//
//  Created by Ali on 8/9/22.
//

// Generated using Sourcery 1.8.2 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
// swiftlint:disable line_length
// swiftlint:disable variable_name

import Foundation
@testable import AdsRepo
#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif
















class RewardedAdRepositoryDelegateMock:NSObject ,RewardedAdRepositoryDelegate {

    //MARK: - rewardedAdRepository

    var rewardedAdRepositoryDidReceiveAdsCallsCount = 0
    var rewardedAdRepositoryDidReceiveAdsCalled: Bool {
        return rewardedAdRepositoryDidReceiveAdsCallsCount > 0
    }
    var rewardedAdRepositoryDidReceiveAdsReceivedRepo: RewardedAdRepository?
    var rewardedAdRepositoryDidReceiveAdsReceivedInvocations: [RewardedAdRepository] = []
    var rewardedAdRepositoryDidReceiveAdsClosure: ((RewardedAdRepository) -> Void)?

    func rewardedAdRepository(didReceiveAds repo: RewardedAdRepository) {
        rewardedAdRepositoryDidReceiveAdsCallsCount += 1
        rewardedAdRepositoryDidReceiveAdsReceivedRepo = repo
        rewardedAdRepositoryDidReceiveAdsReceivedInvocations.append(repo)
        rewardedAdRepositoryDidReceiveAdsClosure?(repo)
    }

    //MARK: - rewardedAdRepository

    var rewardedAdRepositoryDidFinishLoadingErrorCallsCount = 0
    var rewardedAdRepositoryDidFinishLoadingErrorCalled: Bool {
        return rewardedAdRepositoryDidFinishLoadingErrorCallsCount > 0
    }
    var rewardedAdRepositoryDidFinishLoadingErrorReceivedArguments: (repo: RewardedAdRepository, error: Error?)?
    var rewardedAdRepositoryDidFinishLoadingErrorReceivedInvocations: [(repo: RewardedAdRepository, error: Error?)] = []
    var rewardedAdRepositoryDidFinishLoadingErrorClosure: ((RewardedAdRepository, Error?) -> Void)?

    func rewardedAdRepository(didFinishLoading repo: RewardedAdRepository, error: Error?) {
        rewardedAdRepositoryDidFinishLoadingErrorCallsCount += 1
        rewardedAdRepositoryDidFinishLoadingErrorReceivedArguments = (repo: repo, error: error)
        rewardedAdRepositoryDidFinishLoadingErrorReceivedInvocations.append((repo: repo, error: error))
        rewardedAdRepositoryDidFinishLoadingErrorClosure?(repo, error)
    }

}

