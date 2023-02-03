//
//  AdRepositoryReachabilityPorotocolMock.swift
//  AdsRepo-Unit-Tests
//
//  Created by Ali on 1/28/23.
//

// Generated using Sourcery 2.0.0 — https://github.com/krzysztofzablocki/Sourcery
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
















class AdRepositoryReachabilityPorotocolMock: AdRepositoryReachabilityPorotocol {
    var isConnected: Bool {
        get { return underlyingIsConnected }
        set(value) { underlyingIsConnected = value }
    }
    var underlyingIsConnected: Bool!

    //MARK: - setBackOnlineNotifier

    var setBackOnlineNotifierCallsCount = 0
    var setBackOnlineNotifierCalled: Bool {
        return setBackOnlineNotifierCallsCount > 0
    }
    var setBackOnlineNotifierReceivedNotifier: (BackOnlineNotifierClosure)?
    var setBackOnlineNotifierReceivedInvocations: [(BackOnlineNotifierClosure)?] = []
    var setBackOnlineNotifierClosure: ((BackOnlineNotifierClosure?) -> Void)?

    func setBackOnlineNotifier(_ notifier: BackOnlineNotifierClosure?) {
        setBackOnlineNotifierCallsCount += 1
        setBackOnlineNotifierReceivedNotifier = notifier
        setBackOnlineNotifierReceivedInvocations.append(notifier)
        setBackOnlineNotifierClosure?(notifier)
    }

    //MARK: - startNotifier

    var startNotifierCallsCount = 0
    var startNotifierCalled: Bool {
        return startNotifierCallsCount > 0
    }
    var startNotifierClosure: (() -> Void)?

    func startNotifier() {
        startNotifierCallsCount += 1
        startNotifierClosure?()
    }

    //MARK: - stopNotifier

    var stopNotifierCallsCount = 0
    var stopNotifierCalled: Bool {
        return stopNotifierCallsCount > 0
    }
    var stopNotifierClosure: (() -> Void)?

    func stopNotifier() {
        stopNotifierCallsCount += 1
        stopNotifierClosure?()
    }

}
