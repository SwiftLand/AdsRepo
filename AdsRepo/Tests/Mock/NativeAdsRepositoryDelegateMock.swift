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
















class NativeAdsRepositoryDelegateMock:NSObject,NativeAdsRepositoryDelegate {

    //MARK: - nativeAdsRepository

    var nativeAdsRepositoryDidReceiveCallsCount = 0
    var nativeAdsRepositoryDidReceiveCalled: Bool {
        return nativeAdsRepositoryDidReceiveCallsCount > 0
    }
    var nativeAdsRepositoryDidReceiveReceivedRepo: NativeAdsRepository?
    var nativeAdsRepositoryDidReceiveReceivedInvocations: [NativeAdsRepository] = []
    var nativeAdsRepositoryDidReceiveClosure: ((NativeAdsRepository) -> Void)?

    func nativeAdsRepository(didReceive repo: NativeAdsRepository) {
        nativeAdsRepositoryDidReceiveCallsCount += 1
        nativeAdsRepositoryDidReceiveReceivedRepo = repo
        nativeAdsRepositoryDidReceiveReceivedInvocations.append(repo)
        nativeAdsRepositoryDidReceiveClosure?(repo)
    }

    //MARK: - nativeAdsRepository

    var nativeAdsRepositoryDidFinishLoadingErrorCallsCount = 0
    var nativeAdsRepositoryDidFinishLoadingErrorCalled: Bool {
        return nativeAdsRepositoryDidFinishLoadingErrorCallsCount > 0
    }
    var nativeAdsRepositoryDidFinishLoadingErrorReceivedArguments: (repo: NativeAdsRepository, error: Error?)?
    var nativeAdsRepositoryDidFinishLoadingErrorReceivedInvocations: [(repo: NativeAdsRepository, error: Error?)] = []
    var nativeAdsRepositoryDidFinishLoadingErrorClosure: ((NativeAdsRepository, Error?) -> Void)?

    func nativeAdsRepository(didFinishLoading repo: NativeAdsRepository, error: Error?) {
        nativeAdsRepositoryDidFinishLoadingErrorCallsCount += 1
        nativeAdsRepositoryDidFinishLoadingErrorReceivedArguments = (repo: repo, error: error)
        nativeAdsRepositoryDidFinishLoadingErrorReceivedInvocations.append((repo: repo, error: error))
        nativeAdsRepositoryDidFinishLoadingErrorClosure?(repo, error)
    }

}

