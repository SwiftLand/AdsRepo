//
//  NativeAdsRepositoryDelegateMock.swift
//  AdsRepo-Unit-Tests
//
//  Created by Ali on 8/9/22.
//

// Generated using Sourcery 1.8.2 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
// swiftlint:disable line_length
// swiftlint:disable variable_name

import Foundation
import GoogleMobileAds
@testable import AdsRepo
#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif
















class NativeAdRepositoryDelegateMock:NSObject,NativeAdRepositoryDelegate {

    //MARK: - nativeAdRepository

    var nativeAdRepositoryDidReceiveCallsCount = 0
    var nativeAdRepositoryDidReceiveCalled: Bool {
        return nativeAdRepositoryDidReceiveCallsCount > 0
    }
    var nativeAdRepositoryDidReceiveReceivedRepo: NativeAdRepository?
    var nativeAdRepositoryDidReceiveReceivedInvocations: [NativeAdRepository] = []
    var nativeAdRepositoryDidReceiveClosure: ((NativeAdRepository) -> Void)?

    func nativeAdRepository(didReceive repo: NativeAdRepository) {
        nativeAdRepositoryDidReceiveCallsCount += 1
        nativeAdRepositoryDidReceiveReceivedRepo = repo
        nativeAdRepositoryDidReceiveReceivedInvocations.append(repo)
        nativeAdRepositoryDidReceiveClosure?(repo)
    }

    //MARK: - nativeAdRepository

    var nativeAdRepositoryDidFinishLoadingErrorCallsCount = 0
    var nativeAdRepositoryDidFinishLoadingErrorCalled: Bool {
        return nativeAdRepositoryDidFinishLoadingErrorCallsCount > 0
    }
    var nativeAdRepositoryDidFinishLoadingErrorReceivedArguments: (repo: NativeAdRepository, error: Error?)?
    var nativeAdRepositoryDidFinishLoadingErrorReceivedInvocations: [(repo: NativeAdRepository, error: Error?)] = []
    var nativeAdRepositoryDidFinishLoadingErrorClosure: ((NativeAdRepository, Error?) -> Void)?

    func nativeAdRepository(didFinishLoading repo: NativeAdRepository, error: Error?) {
        nativeAdRepositoryDidFinishLoadingErrorCallsCount += 1
        nativeAdRepositoryDidFinishLoadingErrorReceivedArguments = (repo: repo, error: error)
        nativeAdRepositoryDidFinishLoadingErrorReceivedInvocations.append((repo: repo, error: error))
        nativeAdRepositoryDidFinishLoadingErrorClosure?(repo, error)
    }

}

