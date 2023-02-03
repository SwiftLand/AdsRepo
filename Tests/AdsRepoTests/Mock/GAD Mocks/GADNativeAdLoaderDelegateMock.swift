//
//  GADNativeAdLoaderDelegateMock.swift
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
















class GADNativeAdLoaderDelegateMock:NSObject ,GADNativeAdLoaderDelegate {

    //MARK: - adLoader

    var adLoaderDidReceiveCallsCount = 0
    var adLoaderDidReceiveCalled: Bool {
        return adLoaderDidReceiveCallsCount > 0
    }
    var adLoaderDidReceiveReceivedArguments: (adLoader: GADAdLoader, nativeAd: GADNativeAd)?
    var adLoaderDidReceiveReceivedInvocations: [(adLoader: GADAdLoader, nativeAd: GADNativeAd)] = []
    var adLoaderDidReceiveClosure: ((GADAdLoader, GADNativeAd) -> Void)?

    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADNativeAd) {
        adLoaderDidReceiveCallsCount += 1
        adLoaderDidReceiveReceivedArguments = (adLoader: adLoader, nativeAd: nativeAd)
        adLoaderDidReceiveReceivedInvocations.append((adLoader: adLoader, nativeAd: nativeAd))
        adLoaderDidReceiveClosure?(adLoader, nativeAd)
    }

    //MARK: - adLoaderDidFinishLoading

    var adLoaderDidFinishLoadingCallsCount = 0
    var adLoaderDidFinishLoadingCalled: Bool {
        return adLoaderDidFinishLoadingCallsCount > 0
    }
    var adLoaderDidFinishLoadingReceivedAdLoader: GADAdLoader?
    var adLoaderDidFinishLoadingReceivedInvocations: [GADAdLoader] = []
    var adLoaderDidFinishLoadingClosure: ((GADAdLoader) -> Void)?

    func adLoaderDidFinishLoading(_ adLoader: GADAdLoader) {
        adLoaderDidFinishLoadingCallsCount += 1
        adLoaderDidFinishLoadingReceivedAdLoader = adLoader
        adLoaderDidFinishLoadingReceivedInvocations.append(adLoader)
        adLoaderDidFinishLoadingClosure?(adLoader)
    }

    //MARK: - adLoader

    var adLoaderDidFailToReceiveAdWithErrorCallsCount = 0
    var adLoaderDidFailToReceiveAdWithErrorCalled: Bool {
        return adLoaderDidFailToReceiveAdWithErrorCallsCount > 0
    }
    var adLoaderDidFailToReceiveAdWithErrorReceivedArguments: (adLoader: GADAdLoader, error: Error)?
    var adLoaderDidFailToReceiveAdWithErrorReceivedInvocations: [(adLoader: GADAdLoader, error: Error)] = []
    var adLoaderDidFailToReceiveAdWithErrorClosure: ((GADAdLoader, Error) -> Void)?

    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
        adLoaderDidFailToReceiveAdWithErrorCallsCount += 1
        adLoaderDidFailToReceiveAdWithErrorReceivedArguments = (adLoader: adLoader, error: error)
        adLoaderDidFailToReceiveAdWithErrorReceivedInvocations.append((adLoader: adLoader, error: error))
        adLoaderDidFailToReceiveAdWithErrorClosure?(adLoader, error)
    }

}
#endif
