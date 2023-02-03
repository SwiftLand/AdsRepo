//
//  FakeNativeAd.swift
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
















class GADNativeAdMock: GADNativeAd {
    override var headline: String?{
        get{underlyingHeadline}
        set{underlyingHeadline = newValue}
    }
    var underlyingHeadline: String?
    
    override var callToAction: String?{
        get{underlyingCallToAction}
        set{underlyingCallToAction = newValue}
    }
    var underlyingCallToAction: String?
    
    override var icon: GADNativeAdImage?{
        get{underlyingIcon}
        set{underlyingIcon = newValue}
    }
    var underlyingIcon: GADNativeAdImage?
    
    override var body: String?{
        get{underlyingBody}
        set{underlyingBody = newValue}
    }
    var underlyingBody:String?
    
    override var images: [GADNativeAdImage]?{
        get{underlyingImages}
        set{underlyingImages = newValue}
    }
    var underlyingImages:[GADNativeAdImage]?
    
    override var starRating: NSDecimalNumber?{
        get{underlyingStarRating}
        set{underlyingStarRating = newValue}
    }
    var underlyingStarRating:NSDecimalNumber?
    
    override var store: String?{
        get{underlyingStore}
        set{underlyingStore = newValue}
    }
    var underlyingStore: String?
    
    override var price: String?{
        get{underlyingPrice}
        set{underlyingPrice = newValue}
    }
    var underlyingPrice: String?
    
    override var advertiser: String?{
        get{underlyingAdvertiser}
        set{underlyingAdvertiser = newValue}
    }
    var underlyingAdvertiser: String?
    
    override var extraAssets: [String : Any]?{
        get{underlyingExtraAssets}
        set{underlyingExtraAssets = newValue}
    }
    var underlyingExtraAssets: [String : Any]?
   
    override var responseInfo: GADResponseInfo {
        get { return underlyingResponseInfo }
        set { underlyingResponseInfo = newValue }
    }
    var underlyingResponseInfo: GADResponseInfo!
    override var isCustomMuteThisAdAvailable: Bool {
        get { return underlyingCustomMuteThisAdAvailable }
        set { underlyingCustomMuteThisAdAvailable = newValue }
    }
    var underlyingCustomMuteThisAdAvailable: Bool!
    
    override var muteThisAdReasons: [GADMuteThisAdReason]?{
        get{underlyingMuteThisAdReasons}
        set{underlyingMuteThisAdReasons = newValue}
    }
    var underlyingMuteThisAdReasons: [GADMuteThisAdReason]?
    
    //MARK: - register
    
    var registerClickableAssetViewsNonclickableAssetViewsCallsCount = 0
    var registerClickableAssetViewsNonclickableAssetViewsCalled: Bool {
        return registerClickableAssetViewsNonclickableAssetViewsCallsCount > 0
    }
    var registerClickableAssetViewsNonclickableAssetViewsReceivedArguments: (adView: UIView, clickableAssetViews: [GADNativeAssetIdentifier : UIView], nonclickableAssetViews: [GADNativeAssetIdentifier : UIView])?
    var registerClickableAssetViewsNonclickableAssetViewsReceivedInvocations: [(adView: UIView, clickableAssetViews: [GADNativeAssetIdentifier : UIView], nonclickableAssetViews: [GADNativeAssetIdentifier : UIView])] = []
    var registerClickableAssetViewsNonclickableAssetViewsClosure: ((UIView, [GADNativeAssetIdentifier : UIView], [GADNativeAssetIdentifier : UIView]) -> Void)?
    
    override func register(_ adView: UIView, clickableAssetViews: [GADNativeAssetIdentifier : UIView], nonclickableAssetViews: [GADNativeAssetIdentifier : UIView]) {
        registerClickableAssetViewsNonclickableAssetViewsCallsCount += 1
        registerClickableAssetViewsNonclickableAssetViewsReceivedArguments = (adView: adView, clickableAssetViews: clickableAssetViews, nonclickableAssetViews: nonclickableAssetViews)
        registerClickableAssetViewsNonclickableAssetViewsReceivedInvocations.append((adView: adView, clickableAssetViews: clickableAssetViews, nonclickableAssetViews: nonclickableAssetViews))
        registerClickableAssetViewsNonclickableAssetViewsClosure?(adView, clickableAssetViews, nonclickableAssetViews)
    }
    
    //MARK: - unregisterAdView
    
    var unregisterAdViewCallsCount = 0
    var unregisterAdViewCalled: Bool {
        return unregisterAdViewCallsCount > 0
    }
    var unregisterAdViewClosure: (() -> Void)?
    
    override func unregisterAdView() {
        unregisterAdViewCallsCount += 1
        unregisterAdViewClosure?()
    }
    
    //MARK: - muteThisAd
    
    var muteThisAdWithCallsCount = 0
    var muteThisAdWithCalled: Bool {
        return muteThisAdWithCallsCount > 0
    }
    var muteThisAdWithReceivedReason: GADMuteThisAdReason?
    var muteThisAdWithReceivedInvocations: [GADMuteThisAdReason?] = []
    var muteThisAdWithClosure: ((GADMuteThisAdReason?) -> Void)?
    
    override func muteThisAd(with reason: GADMuteThisAdReason?) {
        muteThisAdWithCallsCount += 1
        muteThisAdWithReceivedReason = reason
        muteThisAdWithReceivedInvocations.append(reason)
        muteThisAdWithClosure?(reason)
    }
    
}
#endif
