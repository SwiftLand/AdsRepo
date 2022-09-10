//
//  RewardedAdWrapperDelegateMock.swift
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
















class RewardedAdWrapperDelegateMock:NSObject, RewardedAdWrapperDelegate {

    //MARK: - rewardedAdWrapper

    var rewardedAdWrapperDidReadyCallsCount = 0
    var rewardedAdWrapperDidReadyCalled: Bool {
        return rewardedAdWrapperDidReadyCallsCount > 0
    }
    var rewardedAdWrapperDidReadyReceivedAd: RewardedAdWrapper?
    var rewardedAdWrapperDidReadyReceivedInvocations: [RewardedAdWrapper] = []
    var rewardedAdWrapperDidReadyClosure: ((RewardedAdWrapper) -> Void)?

    func rewardedAdWrapper(didReady ad: RewardedAdWrapper) {
        rewardedAdWrapperDidReadyCallsCount += 1
        rewardedAdWrapperDidReadyReceivedAd = ad
        rewardedAdWrapperDidReadyReceivedInvocations.append(ad)
        rewardedAdWrapperDidReadyClosure?(ad)
    }

    //MARK: - rewardedAdWrapper

    var rewardedAdWrapperDidOpenCallsCount = 0
    var rewardedAdWrapperDidOpenCalled: Bool {
        return rewardedAdWrapperDidOpenCallsCount > 0
    }
    var rewardedAdWrapperDidOpenReceivedAd: RewardedAdWrapper?
    var rewardedAdWrapperDidOpenReceivedInvocations: [RewardedAdWrapper] = []
    var rewardedAdWrapperDidOpenClosure: ((RewardedAdWrapper) -> Void)?

    func rewardedAdWrapper(didOpen ad: RewardedAdWrapper) {
        rewardedAdWrapperDidOpenCallsCount += 1
        rewardedAdWrapperDidOpenReceivedAd = ad
        rewardedAdWrapperDidOpenReceivedInvocations.append(ad)
        rewardedAdWrapperDidOpenClosure?(ad)
    }

    //MARK: - rewardedAdWrapper

    var rewardedAdWrapperWillCloseCallsCount = 0
    var rewardedAdWrapperWillCloseCalled: Bool {
        return rewardedAdWrapperWillCloseCallsCount > 0
    }
    var rewardedAdWrapperWillCloseReceivedAd: RewardedAdWrapper?
    var rewardedAdWrapperWillCloseReceivedInvocations: [RewardedAdWrapper] = []
    var rewardedAdWrapperWillCloseClosure: ((RewardedAdWrapper) -> Void)?

    func rewardedAdWrapper(willClose ad: RewardedAdWrapper) {
        rewardedAdWrapperWillCloseCallsCount += 1
        rewardedAdWrapperWillCloseReceivedAd = ad
        rewardedAdWrapperWillCloseReceivedInvocations.append(ad)
        rewardedAdWrapperWillCloseClosure?(ad)
    }

    //MARK: - rewardedAdWrapper

    var rewardedAdWrapperDidCloseCallsCount = 0
    var rewardedAdWrapperDidCloseCalled: Bool {
        return rewardedAdWrapperDidCloseCallsCount > 0
    }
    var rewardedAdWrapperDidCloseReceivedAd: RewardedAdWrapper?
    var rewardedAdWrapperDidCloseReceivedInvocations: [RewardedAdWrapper] = []
    var rewardedAdWrapperDidCloseClosure: ((RewardedAdWrapper) -> Void)?

    func rewardedAdWrapper(didClose ad: RewardedAdWrapper) {
        rewardedAdWrapperDidCloseCallsCount += 1
        rewardedAdWrapperDidCloseReceivedAd = ad
        rewardedAdWrapperDidCloseReceivedInvocations.append(ad)
        rewardedAdWrapperDidCloseClosure?(ad)
    }

    //MARK: - rewardedAdWrapper

    var rewardedAdWrapperDidShowCountChangedCallsCount = 0
    var rewardedAdWrapperDidShowCountChangedCalled: Bool {
        return rewardedAdWrapperDidShowCountChangedCallsCount > 0
    }
    var rewardedAdWrapperDidShowCountChangedReceivedAd: RewardedAdWrapper?
    var rewardedAdWrapperDidShowCountChangedReceivedInvocations: [RewardedAdWrapper] = []
    var rewardedAdWrapperDidShowCountChangedClosure: ((RewardedAdWrapper) -> Void)?

    func rewardedAdWrapper(didShowCountChanged ad: RewardedAdWrapper) {
        rewardedAdWrapperDidShowCountChangedCallsCount += 1
        rewardedAdWrapperDidShowCountChangedReceivedAd = ad
        rewardedAdWrapperDidShowCountChangedReceivedInvocations.append(ad)
        rewardedAdWrapperDidShowCountChangedClosure?(ad)
    }

    //MARK: - rewardedAdWrapper

    var rewardedAdWrapperDidRemoveFromRepositoryCallsCount = 0
    var rewardedAdWrapperDidRemoveFromRepositoryCalled: Bool {
        return rewardedAdWrapperDidRemoveFromRepositoryCallsCount > 0
    }
    var rewardedAdWrapperDidRemoveFromRepositoryReceivedAd: RewardedAdWrapper?
    var rewardedAdWrapperDidRemoveFromRepositoryReceivedInvocations: [RewardedAdWrapper] = []
    var rewardedAdWrapperDidRemoveFromRepositoryClosure: ((RewardedAdWrapper) -> Void)?

    func rewardedAdWrapper(didRemoveFromRepository ad: RewardedAdWrapper) {
        rewardedAdWrapperDidRemoveFromRepositoryCallsCount += 1
        rewardedAdWrapperDidRemoveFromRepositoryReceivedAd = ad
        rewardedAdWrapperDidRemoveFromRepositoryReceivedInvocations.append(ad)
        rewardedAdWrapperDidRemoveFromRepositoryClosure?(ad)
    }

    //MARK: - rewardedAdWrapper

    var rewardedAdWrapperOnErrorErrorCallsCount = 0
    var rewardedAdWrapperOnErrorErrorCalled: Bool {
        return rewardedAdWrapperOnErrorErrorCallsCount > 0
    }
    var rewardedAdWrapperOnErrorErrorReceivedArguments: (ad: RewardedAdWrapper, error: Error?)?
    var rewardedAdWrapperOnErrorErrorReceivedInvocations: [(ad: RewardedAdWrapper, error: Error?)] = []
    var rewardedAdWrapperOnErrorErrorClosure: ((RewardedAdWrapper, Error?) -> Void)?

    func rewardedAdWrapper(onError ad: RewardedAdWrapper, error: Error?) {
        rewardedAdWrapperOnErrorErrorCallsCount += 1
        rewardedAdWrapperOnErrorErrorReceivedArguments = (ad: ad, error: error)
        rewardedAdWrapperOnErrorErrorReceivedInvocations.append((ad: ad, error: error))
        rewardedAdWrapperOnErrorErrorClosure?(ad, error)
    }

    //MARK: - rewardedAdWrapper

    var rewardedAdWrapperDidRewardRewardCallsCount = 0
    var rewardedAdWrapperDidRewardRewardCalled: Bool {
        return rewardedAdWrapperDidRewardRewardCallsCount > 0
    }
    var rewardedAdWrapperDidRewardRewardReceivedArguments: (ad: RewardedAdWrapper, reward: Double)?
    var rewardedAdWrapperDidRewardRewardReceivedInvocations: [(ad: RewardedAdWrapper, reward: Double)] = []
    var rewardedAdWrapperDidRewardRewardClosure: ((RewardedAdWrapper, Double) -> Void)?

    func rewardedAdWrapper(didReward ad: RewardedAdWrapper, reward: Double) {
        rewardedAdWrapperDidRewardRewardCallsCount += 1
        rewardedAdWrapperDidRewardRewardReceivedArguments = (ad: ad, reward: reward)
        rewardedAdWrapperDidRewardRewardReceivedInvocations.append((ad: ad, reward: reward))
        rewardedAdWrapperDidRewardRewardClosure?(ad, reward)
    }

    //MARK: - rewardedAdWrapper

    var rewardedAdWrapperDidExpireCallsCount = 0
    var rewardedAdWrapperDidExpireCalled: Bool {
        return rewardedAdWrapperDidExpireCallsCount > 0
    }
    var rewardedAdWrapperDidExpireReceivedAd: RewardedAdWrapper?
    var rewardedAdWrapperDidExpireReceivedInvocations: [RewardedAdWrapper] = []
    var rewardedAdWrapperDidExpireClosure: ((RewardedAdWrapper) -> Void)?

    func rewardedAdWrapper(didExpire ad: RewardedAdWrapper) {
        rewardedAdWrapperDidExpireCallsCount += 1
        rewardedAdWrapperDidExpireReceivedAd = ad
        rewardedAdWrapperDidExpireReceivedInvocations.append(ad)
        rewardedAdWrapperDidExpireClosure?(ad)
    }

}

