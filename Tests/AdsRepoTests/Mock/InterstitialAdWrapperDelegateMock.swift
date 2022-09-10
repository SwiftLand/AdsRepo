//
//  InterstitialAdWrapperDelegateMock.swift
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
















class InterstitialAdWrapperDelegateMock: NSObject,InterstitialAdWrapperDelegate {

    //MARK: - interstitialAdWrapper

    var interstitialAdWrapperDidReadyCallsCount = 0
    var interstitialAdWrapperDidReadyCalled: Bool {
        return interstitialAdWrapperDidReadyCallsCount > 0
    }
    var interstitialAdWrapperDidReadyReceivedAd: InterstitialAdWrapper?
    var interstitialAdWrapperDidReadyReceivedInvocations: [InterstitialAdWrapper] = []
    var interstitialAdWrapperDidReadyClosure: ((InterstitialAdWrapper) -> Void)?

    func interstitialAdWrapper(didReady ad: InterstitialAdWrapper) {
        interstitialAdWrapperDidReadyCallsCount += 1
        interstitialAdWrapperDidReadyReceivedAd = ad
        interstitialAdWrapperDidReadyReceivedInvocations.append(ad)
        interstitialAdWrapperDidReadyClosure?(ad)
    }

    //MARK: - interstitialAdWrapper

    var interstitialAdWrapperWillOpenCallsCount = 0
    var interstitialAdWrapperWillOpenCalled: Bool {
        return interstitialAdWrapperWillOpenCallsCount > 0
    }
    var interstitialAdWrapperWillOpenReceivedAd: InterstitialAdWrapper?
    var interstitialAdWrapperWillOpenReceivedInvocations: [InterstitialAdWrapper] = []
    var interstitialAdWrapperWillOpenClosure: ((InterstitialAdWrapper) -> Void)?

    func interstitialAdWrapper(willOpen ad: InterstitialAdWrapper) {
        interstitialAdWrapperWillOpenCallsCount += 1
        interstitialAdWrapperWillOpenReceivedAd = ad
        interstitialAdWrapperWillOpenReceivedInvocations.append(ad)
        interstitialAdWrapperWillOpenClosure?(ad)
    }

    //MARK: - interstitialAdWrapper

    var interstitialAdWrapperWillCloseCallsCount = 0
    var interstitialAdWrapperWillCloseCalled: Bool {
        return interstitialAdWrapperWillCloseCallsCount > 0
    }
    var interstitialAdWrapperWillCloseReceivedAd: InterstitialAdWrapper?
    var interstitialAdWrapperWillCloseReceivedInvocations: [InterstitialAdWrapper] = []
    var interstitialAdWrapperWillCloseClosure: ((InterstitialAdWrapper) -> Void)?

    func interstitialAdWrapper(willClose ad: InterstitialAdWrapper) {
        interstitialAdWrapperWillCloseCallsCount += 1
        interstitialAdWrapperWillCloseReceivedAd = ad
        interstitialAdWrapperWillCloseReceivedInvocations.append(ad)
        interstitialAdWrapperWillCloseClosure?(ad)
    }

    //MARK: - interstitialAdWrapper

    var interstitialAdWrapperDidCloseCallsCount = 0
    var interstitialAdWrapperDidCloseCalled: Bool {
        return interstitialAdWrapperDidCloseCallsCount > 0
    }
    var interstitialAdWrapperDidCloseReceivedAd: InterstitialAdWrapper?
    var interstitialAdWrapperDidCloseReceivedInvocations: [InterstitialAdWrapper] = []
    var interstitialAdWrapperDidCloseClosure: ((InterstitialAdWrapper) -> Void)?

    func interstitialAdWrapper(didClose ad: InterstitialAdWrapper) {
        interstitialAdWrapperDidCloseCallsCount += 1
        interstitialAdWrapperDidCloseReceivedAd = ad
        interstitialAdWrapperDidCloseReceivedInvocations.append(ad)
        interstitialAdWrapperDidCloseClosure?(ad)
    }

    //MARK: - interstitialAdWrapper

    var interstitialAdWrapperDidShowCountChangedCallsCount = 0
    var interstitialAdWrapperDidShowCountChangedCalled: Bool {
        return interstitialAdWrapperDidShowCountChangedCallsCount > 0
    }
    var interstitialAdWrapperDidShowCountChangedReceivedAd: InterstitialAdWrapper?
    var interstitialAdWrapperDidShowCountChangedReceivedInvocations: [InterstitialAdWrapper] = []
    var interstitialAdWrapperDidShowCountChangedClosure: ((InterstitialAdWrapper) -> Void)?

    func interstitialAdWrapper(didShowCountChanged ad: InterstitialAdWrapper) {
        interstitialAdWrapperDidShowCountChangedCallsCount += 1
        interstitialAdWrapperDidShowCountChangedReceivedAd = ad
        interstitialAdWrapperDidShowCountChangedReceivedInvocations.append(ad)
        interstitialAdWrapperDidShowCountChangedClosure?(ad)
    }

    //MARK: - interstitialAdWrapper

    var interstitialAdWrapperDidRemoveFromRepositoryCallsCount = 0
    var interstitialAdWrapperDidRemoveFromRepositoryCalled: Bool {
        return interstitialAdWrapperDidRemoveFromRepositoryCallsCount > 0
    }
    var interstitialAdWrapperDidRemoveFromRepositoryReceivedAd: InterstitialAdWrapper?
    var interstitialAdWrapperDidRemoveFromRepositoryReceivedInvocations: [InterstitialAdWrapper] = []
    var interstitialAdWrapperDidRemoveFromRepositoryClosure: ((InterstitialAdWrapper) -> Void)?

    func interstitialAdWrapper(didRemoveFromRepository ad: InterstitialAdWrapper) {
        interstitialAdWrapperDidRemoveFromRepositoryCallsCount += 1
        interstitialAdWrapperDidRemoveFromRepositoryReceivedAd = ad
        interstitialAdWrapperDidRemoveFromRepositoryReceivedInvocations.append(ad)
        interstitialAdWrapperDidRemoveFromRepositoryClosure?(ad)
    }

    //MARK: - interstitialAdWrapper

    var interstitialAdWrapperOnErrorErrorCallsCount = 0
    var interstitialAdWrapperOnErrorErrorCalled: Bool {
        return interstitialAdWrapperOnErrorErrorCallsCount > 0
    }
    var interstitialAdWrapperOnErrorErrorReceivedArguments: (ad: InterstitialAdWrapper, error: Error?)?
    var interstitialAdWrapperOnErrorErrorReceivedInvocations: [(ad: InterstitialAdWrapper, error: Error?)] = []
    var interstitialAdWrapperOnErrorErrorClosure: ((InterstitialAdWrapper, Error?) -> Void)?

    func interstitialAdWrapper(onError ad: InterstitialAdWrapper, error: Error?) {
        interstitialAdWrapperOnErrorErrorCallsCount += 1
        interstitialAdWrapperOnErrorErrorReceivedArguments = (ad: ad, error: error)
        interstitialAdWrapperOnErrorErrorReceivedInvocations.append((ad: ad, error: error))
        interstitialAdWrapperOnErrorErrorClosure?(ad, error)
    }

    //MARK: - interstitialAdWrapper

    var interstitialAdWrapperDidExpireCallsCount = 0
    var interstitialAdWrapperDidExpireCalled: Bool {
        return interstitialAdWrapperDidExpireCallsCount > 0
    }
    var interstitialAdWrapperDidExpireReceivedAd: InterstitialAdWrapper?
    var interstitialAdWrapperDidExpireReceivedInvocations: [InterstitialAdWrapper] = []
    var interstitialAdWrapperDidExpireClosure: ((InterstitialAdWrapper) -> Void)?

    func interstitialAdWrapper(didExpire ad: InterstitialAdWrapper) {
        interstitialAdWrapperDidExpireCallsCount += 1
        interstitialAdWrapperDidExpireReceivedAd = ad
        interstitialAdWrapperDidExpireReceivedInvocations.append(ad)
        interstitialAdWrapperDidExpireClosure?(ad)
    }

}

