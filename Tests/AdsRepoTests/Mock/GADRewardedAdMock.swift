//
//  FakeRewardedAd.swift
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
















class GADRewardedAdMock: GADRewardedAd {
    override var adUnitID: String {
        get { return underlyingAdUnitID }
        set(value) { underlyingAdUnitID = value }
    }
    var underlyingAdUnitID: String!
    override var responseInfo: GADResponseInfo {
        get { return underlyingResponseInfo }
        set(value) { underlyingResponseInfo = value }
    }
    var underlyingResponseInfo: GADResponseInfo!
    override var adReward: GADAdReward {
        get { return underlyingAdReward }
        set(value) { underlyingAdReward = value }
    }
    var underlyingAdReward: GADAdReward!
    
    override var fullScreenContentDelegate: GADFullScreenContentDelegate?{
        get { return underlyingFullScreenContentDelegate }
        set{ underlyingFullScreenContentDelegate = newValue }
    }
    var underlyingFullScreenContentDelegate:GADFullScreenContentDelegate?
    //MARK: - load
    
    var loadWithAdUnitIDRequestCompletionHandlerCallsCount = 0
    var loadWithAdUnitIDRequestCompletionHandlerCalled: Bool {
        return loadWithAdUnitIDRequestCompletionHandlerCallsCount > 0
    }
    var loadWithAdUnitIDRequestCompletionHandlerReceivedArguments: (adUnitID: String, request: GADRequest?, completionHandler: GADRewardedAdLoadCompletionHandler)?
    var loadWithAdUnitIDRequestCompletionHandlerReceivedInvocations: [(adUnitID: String, request: GADRequest?, completionHandler: GADRewardedAdLoadCompletionHandler)] = []
    var loadWithAdUnitIDRequestCompletionHandlerClosure: ((String, GADRequest?, GADRewardedAdLoadCompletionHandler) -> Void)?
    
    //It have to be `class func` but we use regular func to make it tesable
    func load(withAdUnitID adUnitID: String, request: GADRequest?, completionHandler: @escaping GADRewardedAdLoadCompletionHandler) {
        loadWithAdUnitIDRequestCompletionHandlerCallsCount += 1
        loadWithAdUnitIDRequestCompletionHandlerReceivedArguments = (adUnitID: adUnitID, request: request, completionHandler: completionHandler)
        loadWithAdUnitIDRequestCompletionHandlerReceivedInvocations.append((adUnitID: adUnitID, request: request, completionHandler: completionHandler))
        loadWithAdUnitIDRequestCompletionHandlerClosure?(adUnitID, request, completionHandler)
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
    
    var presentFromRootViewControllerUserDidEarnRewardHandlerCallsCount = 0
    var presentFromRootViewControllerUserDidEarnRewardHandlerCalled: Bool {
        return presentFromRootViewControllerUserDidEarnRewardHandlerCallsCount > 0
    }
    var presentFromRootViewControllerUserDidEarnRewardHandlerReceivedArguments: (rootViewController: UIViewController, userDidEarnRewardHandler: GADUserDidEarnRewardHandler)?
    var presentFromRootViewControllerUserDidEarnRewardHandlerReceivedInvocations: [(rootViewController: UIViewController, userDidEarnRewardHandler: GADUserDidEarnRewardHandler)] = []
    var presentFromRootViewControllerUserDidEarnRewardHandlerClosure: ((UIViewController, GADUserDidEarnRewardHandler) -> Void)?
    
    override func present(fromRootViewController rootViewController: UIViewController, userDidEarnRewardHandler: @escaping GADUserDidEarnRewardHandler) {
        presentFromRootViewControllerUserDidEarnRewardHandlerCallsCount += 1
        presentFromRootViewControllerUserDidEarnRewardHandlerReceivedArguments = (rootViewController: rootViewController, userDidEarnRewardHandler: userDidEarnRewardHandler)
        presentFromRootViewControllerUserDidEarnRewardHandlerReceivedInvocations.append((rootViewController: rootViewController, userDidEarnRewardHandler: userDidEarnRewardHandler))
        presentFromRootViewControllerUserDidEarnRewardHandlerClosure?(rootViewController, userDidEarnRewardHandler)
    }
    
    //MARK: - load
    static var error:NSError? = nil
    override class func load(withAdUnitID adUnitID: String, request: GADRequest?, completionHandler: @escaping GADRewardedAdLoadCompletionHandler) {
        guard error == nil else{
            completionHandler(nil,error)
            return
        }
        let ad = GADRewardedAdMock()
        completionHandler(ad,error)
    }
}
