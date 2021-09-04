//
//  NativeAdWrapper.swift
//  WidgetBox
//
//  Created by Ali on 9/2/21.
//

import Foundation
import GoogleMobileAds

public protocol NativeAdWrapperProtocol {
    var repoConfig:RepoConfig{get}
    var loadedAd: GADNativeAd{get}
    var loadedDate:Date{get}
    var showCount:Int{get}
    var loadCount:Int{get}
    var referenceCount:Int{get}
}
class NativeAdWrapper:NSObject,NativeAdWrapperProtocol{
     var repoConfig:RepoConfig
     var loadedAd: GADNativeAd
     var loadedDate:Date = Date()
     var showCount:Int = 0
     var loadCount:Int = 0
     var referenceCount:Int = 0
    
    init(repoConfig:RepoConfig,loadedAd: GADNativeAd) {
        self.repoConfig = repoConfig
        self.loadedAd = loadedAd
        super.init()
        self.loadedAd.delegate = self
    }
}

extension NativeAdWrapper: GADNativeAdDelegate {

     func nativeAdDidRecordClick(_ nativeAd: GADNativeAd) {
        print("native ad RecordClick")
    }
     func nativeAdDidDismissScreen(_ nativeAd: GADNativeAd) {
        print("native ad DidDismiss")
    }
     func nativeAdWillPresentScreen(_ nativeAd: GADNativeAd) {
        print("native ad AdWillPresent")
    }
     func nativeAdWillDismissScreen(_ nativeAd: GADNativeAd) {
        print("native ad AdWillDismiss")
    }
     func nativeAdDidRecordImpression(_ nativeAd: GADNativeAd) {
        print("native ad RecordImpression")
        showCount += 1
    }
     func nativeAdIsMuted(_ nativeAd: GADNativeAd) {
        print("native ad IsMuted")
    }
}
