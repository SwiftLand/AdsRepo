//
//  NativeAdWrapper.swift
//  WidgetBox
//
//  Created by Ali on 9/2/21.
//

import Foundation
import GoogleMobileAds

protocol NativeAdWrapperDelegate {
    func nativeAd(didReady ad:NativeAdWrapper)
    func nativeAd(willShown ad:NativeAdWrapper)
    func nativeAd(willDismiss ad:NativeAdWrapper)
    func nativeAd(didDismiss ad:NativeAdWrapper)
    func nativeAd(onError ad:NativeAdWrapper,error:Error?)
    func nativeAd(didExpire ad:NativeAdWrapper)
    func nativeAd(didClicked ad:NativeAdWrapper)
    func nativeAd(didRecordImpression ad:NativeAdWrapper)
    func nativeAd(_ ad:NativeAdWrapper,isMuted:Bool)
}

public class NativeAdWrapper:NSObject{
    public private(set) var repoConfig:RepoConfig
    public private(set) var loadedAd: GADNativeAd
    public private(set) var loadedDate:TimeInterval = Date().timeIntervalSince1970
    public private(set) var showCount:Int = 0
    public private(set) var referenceCount:Int = 0
     private var timer:Timer? = nil
     private var owner:NativeAdsController? = nil
    init(repoConfig:RepoConfig,loadedAd: GADNativeAd,owner:NativeAdsController? = nil) {
        self.repoConfig = repoConfig
        self.loadedAd = loadedAd
        super.init()
        self.owner = owner
        self.loadedAd.delegate = self
        self.loadedAd.mediaContent.videoController.delegate = self
        
        self.timer = Timer.scheduledTimer(withTimeInterval: self.repoConfig.expireIntervalTime, repeats: false, block: {[weak self]  timer in
            guard let self = self else {return}
            print("Native Ad was expire")
            self.owner?.nativeAd(didExpire: self)
        })
    }
    
    deinit {
        timer?.invalidate()
        timer = nil
        print("deinit","Native Ad")
    }
}

extension NativeAdWrapper: GADNativeAdDelegate {

    public func nativeAdDidRecordClick(_ nativeAd: GADNativeAd) {
        print("NativeAd","RecordClick")
        self.owner?.nativeAd(didClicked: self)
    }
    public func nativeAdDidDismissScreen(_ nativeAd: GADNativeAd) {
        print("NativeAd","DidDismiss")
         self.owner?.nativeAd(didDismiss: self)
    }
    public func nativeAdWillPresentScreen(_ nativeAd: GADNativeAd) {
         print("NativeAd","AdWillPresent")
         self.showCount += 1
         self.owner?.nativeAd(willShown: self)
    }
    public func nativeAdWillDismissScreen(_ nativeAd: GADNativeAd) {
         print("NativeAd","AdWillDismiss")
         self.owner?.nativeAd(willDismiss: self)
    }
    public func nativeAdDidRecordImpression(_ nativeAd: GADNativeAd) {
        print("NativeAd","RecordImpression")
        self.owner?.nativeAd(didRecordImpression: self)
    }
    public func nativeAdIsMuted(_ nativeAd: GADNativeAd) {
        print("NativeAd","IsMuted")
        self.owner?.nativeAd(self,isMuted: true)
    }
}
extension NativeAdWrapper:GADVideoControllerDelegate{
    // GADVideoControllerDelegate methods
    public func videoControllerDidPlayVideo(_ videoController: GADVideoController) {
        // Implement this method to receive a notification when the video controller
        // begins playing the ad.
        print("NativeAd","DidPlayVideo")
      }

    public func videoControllerDidPauseVideo(_ videoController: GADVideoController) {
        // Implement this method to receive a notification when the video controller
        // pauses the ad.
        print("NativeAd","DidPauseVideo")
      }

    public func videoControllerDidEndVideoPlayback(_ videoController: GADVideoController) {
        // Implement this method to receive a notification when the video controller
        // stops playing the ad.
        print("NativeAd","DidEndVideoPlayback")
      }

    public func videoControllerDidMuteVideo(_ videoController: GADVideoController) {
        // Implement this method to receive a notification when the video controller
        // mutes the ad.
        print("NativeAd","DidMuteVideo")
      }

    public func videoControllerDidUnmuteVideo(_ videoController: GADVideoController) {
        // Implement this method to receive a notification when the video controller
        // unmutes the ad.
        print("NativeAd","DidUnmuteVideo")
      }
}
