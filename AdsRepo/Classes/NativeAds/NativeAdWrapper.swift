//
//  NativeAdWrapper.swift
//  WidgetBox
//
//  Created by Ali on 9/2/21.
//

import Foundation
import GoogleMobileAds


protocol NativeAdWrapperDelegate{
    func nativeAdWrapper(didExpire ad:NativeAdWrapper)
}
public protocol NativeAdWrapperProtocol {
    var repoConfig:RepoConfig{get}
    var loadedAd: GADNativeAd{get}
    var loadedDate:TimeInterval{get}
    var showCount:Int{get}
    var referenceCount:Int{get}
}
class NativeAdWrapper:NSObject,NativeAdWrapperProtocol{
     var repoConfig:RepoConfig
     var loadedAd: GADNativeAd
     var loadedDate:TimeInterval = Date().timeIntervalSince1970 * 1000
     var showCount:Int = 0
     var referenceCount:Int = 0
     private var timer:Timer? = nil
     private var delegate:NativeAdWrapperDelegate? = nil
    init(repoConfig:RepoConfig,loadedAd: GADNativeAd,delegate:NativeAdWrapperDelegate? = nil) {
        self.repoConfig = repoConfig
        self.loadedAd = loadedAd
        super.init()
        self.delegate = delegate
        self.loadedAd.delegate = self
        self.loadedAd.mediaContent.videoController.delegate = self
        self.timer = Timer(fireAt: Date().addingTimeInterval(self.repoConfig.expireIntervalTime), interval: 0, target: self, selector: #selector(self.makeAdExpire), userInfo: nil, repeats: false)
    }
    
    @objc func makeAdExpire() {
        print("Native Ad was expire")
        delegate?.nativeAdWrapper(didExpire: self)
    }
    deinit {
        timer?.invalidate()
        timer = nil
        print("deinit","Native Ad")
    }
}

extension NativeAdWrapper: GADNativeAdDelegate {

     func nativeAdDidRecordClick(_ nativeAd: GADNativeAd) {
        print("NativeAd","RecordClick")
    }
     func nativeAdDidDismissScreen(_ nativeAd: GADNativeAd) {
        print("NativeAd","DidDismiss")
    }
     func nativeAdWillPresentScreen(_ nativeAd: GADNativeAd) {
        print("NativeAd","AdWillPresent")
    }
     func nativeAdWillDismissScreen(_ nativeAd: GADNativeAd) {
        print("NativeAd","AdWillDismiss")
    }
     func nativeAdDidRecordImpression(_ nativeAd: GADNativeAd) {
        print("NativeAd","RecordImpression")
    }
     func nativeAdIsMuted(_ nativeAd: GADNativeAd) {
        print("NativeAd","IsMuted")
    }
}
extension NativeAdWrapper:GADVideoControllerDelegate{
    // GADVideoControllerDelegate methods
      func videoControllerDidPlayVideo(_ videoController: GADVideoController) {
        // Implement this method to receive a notification when the video controller
        // begins playing the ad.
        print("NativeAd","DidPlayVideo")
      }

      func videoControllerDidPauseVideo(_ videoController: GADVideoController) {
        // Implement this method to receive a notification when the video controller
        // pauses the ad.
        print("NativeAd","DidPauseVideo")
      }

      func videoControllerDidEndVideoPlayback(_ videoController: GADVideoController) {
        // Implement this method to receive a notification when the video controller
        // stops playing the ad.
        print("NativeAd","DidEndVideoPlayback")
      }

      func videoControllerDidMuteVideo(_ videoController: GADVideoController) {
        // Implement this method to receive a notification when the video controller
        // mutes the ad.
        print("NativeAd","DidMuteVideo")
      }

      func videoControllerDidUnmuteVideo(_ videoController: GADVideoController) {
        // Implement this method to receive a notification when the video controller
        // unmutes the ad.
        print("NativeAd","DidUnmuteVideo")
      }
}
