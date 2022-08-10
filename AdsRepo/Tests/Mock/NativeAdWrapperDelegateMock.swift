//
//  NativeAdWrapperDelegateMock.swift
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
















class NativeAdWrapperDelegateMock:NSObject, NativeAdWrapperDelegate {

    //MARK: - nativeAdWrapper

    var nativeAdWrapperDidRemoveFromRepositoryCallsCount = 0
    var nativeAdWrapperDidRemoveFromRepositoryCalled: Bool {
        return nativeAdWrapperDidRemoveFromRepositoryCallsCount > 0
    }
    var nativeAdWrapperDidRemoveFromRepositoryReceivedAd: NativeAdWrapper?
    var nativeAdWrapperDidRemoveFromRepositoryReceivedInvocations: [NativeAdWrapper] = []
    var nativeAdWrapperDidRemoveFromRepositoryClosure: ((NativeAdWrapper) -> Void)?

    func nativeAdWrapper(didRemoveFromRepository ad: NativeAdWrapper) {
        nativeAdWrapperDidRemoveFromRepositoryCallsCount += 1
        nativeAdWrapperDidRemoveFromRepositoryReceivedAd = ad
        nativeAdWrapperDidRemoveFromRepositoryReceivedInvocations.append(ad)
        nativeAdWrapperDidRemoveFromRepositoryClosure?(ad)
    }

    //MARK: - nativeAdWrapper

    var nativeAdWrapperDidShowCountChangedCallsCount = 0
    var nativeAdWrapperDidShowCountChangedCalled: Bool {
        return nativeAdWrapperDidShowCountChangedCallsCount > 0
    }
    var nativeAdWrapperDidShowCountChangedReceivedAd: NativeAdWrapper?
    var nativeAdWrapperDidShowCountChangedReceivedInvocations: [NativeAdWrapper] = []
    var nativeAdWrapperDidShowCountChangedClosure: ((NativeAdWrapper) -> Void)?

    func nativeAdWrapper(didShowCountChanged ad: NativeAdWrapper) {
        nativeAdWrapperDidShowCountChangedCallsCount += 1
        nativeAdWrapperDidShowCountChangedReceivedAd = ad
        nativeAdWrapperDidShowCountChangedReceivedInvocations.append(ad)
        nativeAdWrapperDidShowCountChangedClosure?(ad)
    }

    //MARK: - nativeAdWrapper

    var nativeAdWrapperDidExpireCallsCount = 0
    var nativeAdWrapperDidExpireCalled: Bool {
        return nativeAdWrapperDidExpireCallsCount > 0
    }
    var nativeAdWrapperDidExpireReceivedAd: NativeAdWrapper?
    var nativeAdWrapperDidExpireReceivedInvocations: [NativeAdWrapper] = []
    var nativeAdWrapperDidExpireClosure: ((NativeAdWrapper) -> Void)?

    func nativeAdWrapper(didExpire ad: NativeAdWrapper) {
        nativeAdWrapperDidExpireCallsCount += 1
        nativeAdWrapperDidExpireReceivedAd = ad
        nativeAdWrapperDidExpireReceivedInvocations.append(ad)
        nativeAdWrapperDidExpireClosure?(ad)
    }

}

