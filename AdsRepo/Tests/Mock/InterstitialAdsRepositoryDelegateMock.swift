//
//  InterstitialAdsRepositoryDelegateMock.swift
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
















class InterstitialAdsRepositoryDelegateMock: NSObject,InterstitialAdsRepositoryDelegate {

    //MARK: - interstitialAdsRepository

    var interstitialAdsRepositoryDidReceiveCallsCount = 0
    var interstitialAdsRepositoryDidReceiveCalled: Bool {
        return interstitialAdsRepositoryDidReceiveCallsCount > 0
    }
    var interstitialAdsRepositoryDidReceiveReceivedRepo: InterstitialAdsRepository?
    var interstitialAdsRepositoryDidReceiveReceivedInvocations: [InterstitialAdsRepository] = []
    var interstitialAdsRepositoryDidReceiveClosure: ((InterstitialAdsRepository) -> Void)?

    func interstitialAdsRepository(didReceive repo: InterstitialAdsRepository) {
        interstitialAdsRepositoryDidReceiveCallsCount += 1
        interstitialAdsRepositoryDidReceiveReceivedRepo = repo
        interstitialAdsRepositoryDidReceiveReceivedInvocations.append(repo)
        interstitialAdsRepositoryDidReceiveClosure?(repo)
    }

    //MARK: - interstitialAdsRepository

    var interstitialAdsRepositoryDidFinishLoadingErrorCallsCount = 0
    var interstitialAdsRepositoryDidFinishLoadingErrorCalled: Bool {
        return interstitialAdsRepositoryDidFinishLoadingErrorCallsCount > 0
    }
    var interstitialAdsRepositoryDidFinishLoadingErrorReceivedArguments: (repo: InterstitialAdsRepository, error: Error?)?
    var interstitialAdsRepositoryDidFinishLoadingErrorReceivedInvocations: [(repo: InterstitialAdsRepository, error: Error?)] = []
    var interstitialAdsRepositoryDidFinishLoadingErrorClosure: ((InterstitialAdsRepository, Error?) -> Void)?

    func interstitialAdsRepository(didFinishLoading repo: InterstitialAdsRepository, error: Error?) {
        interstitialAdsRepositoryDidFinishLoadingErrorCallsCount += 1
        interstitialAdsRepositoryDidFinishLoadingErrorReceivedArguments = (repo: repo, error: error)
        interstitialAdsRepositoryDidFinishLoadingErrorReceivedInvocations.append((repo: repo, error: error))
        interstitialAdsRepositoryDidFinishLoadingErrorClosure?(repo, error)
    }

}

