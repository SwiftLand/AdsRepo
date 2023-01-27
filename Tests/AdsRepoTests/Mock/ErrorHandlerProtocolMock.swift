//
//  ErrorHandlerProtocolMock.swift
//  AdsRepo-Unit-Tests
//
//  Created by Ali on 8/12/22.
//

/// Generated using Sourcery 2.0.0 — https://github.com/krzysztofzablocki/Sourcery
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
















class AdRepositoryErrorHandlerProtocolMock: AdRepositoryErrorHandlerProtocol {

    //MARK: - isRetryAble

    var isRetryAbleErrorCallsCount = 0
    var isRetryAbleErrorCalled: Bool {
        return isRetryAbleErrorCallsCount > 0
    }
    var isRetryAbleErrorReceivedError: Error?
    var isRetryAbleErrorReceivedInvocations: [Error] = []
    var isRetryAbleErrorReturnValue: Bool!
    var isRetryAbleErrorClosure: ((Error) -> Bool)?

    func isRetryAble(error: Error) -> Bool {
        isRetryAbleErrorCallsCount += 1
        isRetryAbleErrorReceivedError = error
        isRetryAbleErrorReceivedInvocations.append(error)
        if let isRetryAbleErrorClosure = isRetryAbleErrorClosure {
            return isRetryAbleErrorClosure(error)
        } else {
            return isRetryAbleErrorReturnValue
        }
    }

    //MARK: - requestForRetry

    var requestForRetryOnRetryCallsCount = 0
    var requestForRetryOnRetryCalled: Bool {
        return requestForRetryOnRetryCallsCount > 0
    }
    var requestForRetryOnRetryReceivedRetry: (RetryClosure)?
    var requestForRetryOnRetryReceivedInvocations: [(RetryClosure)] = []
    var requestForRetryOnRetryClosure: ((@escaping RetryClosure) -> Void)?

    func requestForRetry(onRetry retry: @escaping RetryClosure) {
        requestForRetryOnRetryCallsCount += 1
        requestForRetryOnRetryReceivedRetry = retry
        requestForRetryOnRetryReceivedInvocations.append(retry)
        requestForRetryOnRetryClosure?(retry)
    }

    //MARK: - restart

    var restartCallsCount = 0
    var restartCalled: Bool {
        return restartCallsCount > 0
    }
    var restartClosure: (() -> Void)?

    func restart() {
        restartCallsCount += 1
        restartClosure?()
    }

    //MARK: - cancel

    var cancelCallsCount = 0
    var cancelCalled: Bool {
        return cancelCallsCount > 0
    }
    var cancelClosure: (() -> Void)?

    func cancel() {
        cancelCallsCount += 1
        cancelClosure?()
    }

}
