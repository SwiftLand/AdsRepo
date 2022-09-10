//
//  InterstitialAdRepositoryDelegateMock.swift
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
















class InterstitialAdRepositoryDelegateMock: NSObject,InterstitialAdRepositoryDelegate {

    //MARK: - interstitialAdRepository

    var interstitialAdRepositoryDidReceiveCallsCount = 0
    var interstitialAdRepositoryDidReceiveCalled: Bool {
        return interstitialAdRepositoryDidReceiveCallsCount > 0
    }
    var interstitialAdRepositoryDidReceiveReceivedRepo: InterstitialAdRepository?
    var interstitialAdRepositoryDidReceiveReceivedInvocations: [InterstitialAdRepository] = []
    var interstitialAdRepositoryDidReceiveClosure: ((InterstitialAdRepository) -> Void)?

    func interstitialAdRepository(didReceive repo: InterstitialAdRepository) {
        interstitialAdRepositoryDidReceiveCallsCount += 1
        interstitialAdRepositoryDidReceiveReceivedRepo = repo
        interstitialAdRepositoryDidReceiveReceivedInvocations.append(repo)
        interstitialAdRepositoryDidReceiveClosure?(repo)
    }

    //MARK: - interstitialAdRepository

    var interstitialAdRepositoryDidFinishLoadingErrorCallsCount = 0
    var interstitialAdRepositoryDidFinishLoadingErrorCalled: Bool {
        return interstitialAdRepositoryDidFinishLoadingErrorCallsCount > 0
    }
    var interstitialAdRepositoryDidFinishLoadingErrorReceivedArguments: (repo: InterstitialAdRepository, error: Error?)?
    var interstitialAdRepositoryDidFinishLoadingErrorReceivedInvocations: [(repo: InterstitialAdRepository, error: Error?)] = []
    var interstitialAdRepositoryDidFinishLoadingErrorClosure: ((InterstitialAdRepository, Error?) -> Void)?

    func interstitialAdRepository(didFinishLoading repo: InterstitialAdRepository, error: Error?) {
        interstitialAdRepositoryDidFinishLoadingErrorCallsCount += 1
        interstitialAdRepositoryDidFinishLoadingErrorReceivedArguments = (repo: repo, error: error)
        interstitialAdRepositoryDidFinishLoadingErrorReceivedInvocations.append((repo: repo, error: error))
        interstitialAdRepositoryDidFinishLoadingErrorClosure?(repo, error)
    }

}

