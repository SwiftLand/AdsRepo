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
















class RewardedAdsRepositoryDelegateMock:NSObject ,RewardedAdsRepositoryDelegate {

    //MARK: - rewardedAdsRepository

    var rewardedAdsRepositoryDidReceiveAdsCallsCount = 0
    var rewardedAdsRepositoryDidReceiveAdsCalled: Bool {
        return rewardedAdsRepositoryDidReceiveAdsCallsCount > 0
    }
    var rewardedAdsRepositoryDidReceiveAdsReceivedRepo: RewardedAdsRepository?
    var rewardedAdsRepositoryDidReceiveAdsReceivedInvocations: [RewardedAdsRepository] = []
    var rewardedAdsRepositoryDidReceiveAdsClosure: ((RewardedAdsRepository) -> Void)?

    func rewardedAdsRepository(didReceiveAds repo: RewardedAdsRepository) {
        rewardedAdsRepositoryDidReceiveAdsCallsCount += 1
        rewardedAdsRepositoryDidReceiveAdsReceivedRepo = repo
        rewardedAdsRepositoryDidReceiveAdsReceivedInvocations.append(repo)
        rewardedAdsRepositoryDidReceiveAdsClosure?(repo)
    }

    //MARK: - rewardedAdsRepository

    var rewardedAdsRepositoryDidFinishLoadingErrorCallsCount = 0
    var rewardedAdsRepositoryDidFinishLoadingErrorCalled: Bool {
        return rewardedAdsRepositoryDidFinishLoadingErrorCallsCount > 0
    }
    var rewardedAdsRepositoryDidFinishLoadingErrorReceivedArguments: (repo: RewardedAdsRepository, error: Error?)?
    var rewardedAdsRepositoryDidFinishLoadingErrorReceivedInvocations: [(repo: RewardedAdsRepository, error: Error?)] = []
    var rewardedAdsRepositoryDidFinishLoadingErrorClosure: ((RewardedAdsRepository, Error?) -> Void)?

    func rewardedAdsRepository(didFinishLoading repo: RewardedAdsRepository, error: Error?) {
        rewardedAdsRepositoryDidFinishLoadingErrorCallsCount += 1
        rewardedAdsRepositoryDidFinishLoadingErrorReceivedArguments = (repo: repo, error: error)
        rewardedAdsRepositoryDidFinishLoadingErrorReceivedInvocations.append((repo: repo, error: error))
        rewardedAdsRepositoryDidFinishLoadingErrorClosure?(repo, error)
    }

}

