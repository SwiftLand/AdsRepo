//
//  AdRepositoryDelegateMock.swift
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
















class AdRepositoryDelegateMock:NSObject,AdRepositoryDelegate {

    //MARK: - didReceive

    var adRepositoryDidReceiveCallsCount = 0
    var adRepositoryDidReceiveCalled: Bool {
        return adRepositoryDidReceiveCallsCount > 0
    }
    var adRepositoryDidReceiveReceivedRepository: AnyRepositoryType?
    var adRepositoryDidReceiveReceivedInvocations: [AnyRepositoryType] = []
    var adRepositoryDidReceiveClosure: ((AnyRepositoryType) -> Void)?

    func adRepository(didReceive repository: AnyRepositoryType) {
        adRepositoryDidReceiveCallsCount += 1
        adRepositoryDidReceiveReceivedRepository = repository
        adRepositoryDidReceiveReceivedInvocations.append(repository)
        adRepositoryDidReceiveClosure?(repository)
    }

    //MARK: - didFinishLoading

    var adRepositoryDidFinishLoadingErrorCallsCount = 0
    var adRepositoryDidFinishLoadingErrorCalled: Bool {
        return adRepositoryDidFinishLoadingErrorCallsCount > 0
    }
    var adRepositoryDidFinishLoadingErrorReceivedArguments: (repository: AnyRepositoryType, error: Error?)?
    var adRepositoryDidFinishLoadingErrorReceivedInvocations: [(repository: AnyRepositoryType, error: Error?)] = []
    var adRepositoryDidFinishLoadingErrorClosure: ((AnyRepositoryType, Error?) -> Void)?

    func adRepository(didFinishLoading repository: AnyRepositoryType, error: Error?) {
        adRepositoryDidFinishLoadingErrorCallsCount += 1
        adRepositoryDidFinishLoadingErrorReceivedArguments = (repository: repository, error: error)
        adRepositoryDidFinishLoadingErrorReceivedInvocations.append((repository: repository, error: error))
        adRepositoryDidFinishLoadingErrorClosure?(repository, error)
    }

    //MARK: - didExpire

    var adRepositoryDidExpireInCallsCount = 0
    var adRepositoryDidExpireInCalled: Bool {
        return adRepositoryDidExpireInCallsCount > 0
    }
    var adRepositoryDidExpireInReceivedArguments: (ad: AnyAdType, repository: AnyRepositoryType)?
    var adRepositoryDidExpireInReceivedInvocations: [(ad: AnyAdType, repository: AnyRepositoryType)] = []
    var adRepositoryDidExpireInClosure: ((AnyAdType, AnyRepositoryType) -> Void)?

    func adRepository(didExpire ad: AnyAdType, in repository: AnyRepositoryType) {
        adRepositoryDidExpireInCallsCount += 1
        adRepositoryDidExpireInReceivedArguments = (ad: ad, repository: repository)
        adRepositoryDidExpireInReceivedInvocations.append((ad: ad, repository: repository))
        adRepositoryDidExpireInClosure?(ad, repository)
    }

    //MARK: - didRemove

    var adRepositoryDidRemoveInCallsCount = 0
    var adRepositoryDidRemoveInCalled: Bool {
        return adRepositoryDidRemoveInCallsCount > 0
    }
    var adRepositoryDidRemoveInReceivedArguments: (ad: AnyAdType, repository: AnyRepositoryType)?
    var adRepositoryDidRemoveInReceivedInvocations: [(ad: AnyAdType, repository: AnyRepositoryType)] = []
    var adRepositoryDidRemoveInClosure: ((AnyAdType, AnyRepositoryType) -> Void)?

    func adRepository(didRemove ad: AnyAdType, in repository: AnyRepositoryType) {
        adRepositoryDidRemoveInCallsCount += 1
        adRepositoryDidRemoveInReceivedArguments = (ad: ad, repository: repository)
        adRepositoryDidRemoveInReceivedInvocations.append((ad: ad, repository: repository))
        adRepositoryDidRemoveInClosure?(ad, repository)
    }

}

