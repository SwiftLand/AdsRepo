//
//  FakeAd.swift
//  AdsRepo-Unit-Tests
//
//  Created by Ali on 8/9/22.
//

// Generated using Sourcery 1.8.2 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
// swiftlint:disable line_length
// swiftlint:disable variable_name

#if canImport(GoogleMobileAds)
import Foundation
import GoogleMobileAds
@testable import AdsRepo
#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif
















class GADInterstitialAdMock: GADInterstitialAd {
    override var adUnitID: String {
        get { return underlyingAdUnitID }
        set { underlyingAdUnitID = newValue }
    }
    var underlyingAdUnitID: String!
    override var responseInfo: GADResponseInfo {
        get { return underlyingResponseInfo }
        set { underlyingResponseInfo = newValue }
    }
    var underlyingResponseInfo: GADResponseInfo!
    
    override var fullScreenContentDelegate: GADFullScreenContentDelegate?{
        get { return underlyingFullScreenContentDelegate }
        set{ underlyingFullScreenContentDelegate = newValue }
    }
    var underlyingFullScreenContentDelegate:GADFullScreenContentDelegate?
    //MARK: - load
    
    var loadCallsCount = 0
    var loadCalled: Bool {
        return loadCallsCount > 0
    }
    var loadClosure: (() -> Void)?
    
    func load() {
        loadCallsCount += 1
        loadClosure?()
    }
    
    //MARK: - canPresent
    
    var canPresentFromRootViewControllerCallsCount = 0
    var canPresentFromRootViewControllerCalled: Bool {
        return canPresentFromRootViewControllerCallsCount > 0
    }
    var canPresentFromRootViewControllerReceivedRootViewController: UIViewController?
    var canPresentFromRootViewControllerReceivedInvocations: [UIViewController] = []
    var canPresentFromRootViewControllerClosure: ((UIViewController) -> Void)?
    
    override func canPresent(fromRootViewController rootViewController: UIViewController) throws{
        canPresentFromRootViewControllerCallsCount += 1
        canPresentFromRootViewControllerReceivedRootViewController = rootViewController
        canPresentFromRootViewControllerReceivedInvocations.append(rootViewController)
        canPresentFromRootViewControllerClosure?(rootViewController)
    }
    
    //MARK: - present
    
    var presentFromRootViewControllerCallsCount = 0
    var presentFromRootViewControllerCalled: Bool {
        return presentFromRootViewControllerCallsCount > 0
    }
    var presentFromRootViewControllerReceivedRootViewController: UIViewController?
    var presentFromRootViewControllerReceivedInvocations: [UIViewController] = []
    var presentFromRootViewControllerClosure: ((UIViewController) -> Void)?
    
    override func present(fromRootViewController rootViewController: UIViewController) {
        presentFromRootViewControllerCallsCount += 1
        presentFromRootViewControllerReceivedRootViewController = rootViewController
        presentFromRootViewControllerReceivedInvocations.append(rootViewController)
        presentFromRootViewControllerClosure?(rootViewController)
    }
    
    //MARK: - load
    static var error:NSError? = nil
    override class func load(withAdUnitID adUnitID: String, request: GADRequest?, completionHandler: @escaping GADInterstitialAdLoadCompletionHandler) {
        guard error == nil else{
            completionHandler(nil,error)
            return
        }
        let ad = GADInterstitialAdMock()
        completionHandler(ad,error)
    }
}

#endif
