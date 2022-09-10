//
//  ErrorHandlerProtocolMock.swift
//  AdsRepo-Unit-Tests
//
//  Created by Ali on 8/12/22.
//

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
















class ErrorHandlerProtocolMock: ErrorHandlerProtocol {
    var config: ErrorHandlerConfig {
        get { return underlyingConfig }
        set(value) { underlyingConfig = value }
    }
    var underlyingConfig: ErrorHandlerConfig!
    
    //MARK: - isRetryAble

    var isRetryAbleErrorRetryClosureCallsCount = 0
    var isRetryAbleErrorRetryClosureCalled: Bool {
        return isRetryAbleErrorRetryClosureCallsCount > 0
    }
    var isRetryAbleErrorRetryClosureReceivedArguments: (error: Error?, retryClosure: RetryClosure?)?
    var isRetryAbleErrorRetryClosureReceivedInvocations: [(error: Error?, retryClosure: RetryClosure?)] = []
    var isRetryAbleErrorRetryClosureReturnValue: Bool!
    var isRetryAbleErrorRetryClosureClosure: ((Error?, RetryClosure?) -> Bool)?

    func isRetryAble(error: Error?, retryClosure: RetryClosure?) -> Bool {
        isRetryAbleErrorRetryClosureCallsCount += 1
        isRetryAbleErrorRetryClosureReceivedArguments = (error: error, retryClosure: retryClosure)
        isRetryAbleErrorRetryClosureReceivedInvocations.append((error: error, retryClosure: retryClosure))
        if let isRetryAbleErrorRetryClosureClosure = isRetryAbleErrorRetryClosureClosure {
            return isRetryAbleErrorRetryClosureClosure(error, retryClosure)
        } else {
            return isRetryAbleErrorRetryClosureReturnValue
        }
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
