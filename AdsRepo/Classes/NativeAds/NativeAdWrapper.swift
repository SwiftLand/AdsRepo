//
//  NativeAdWrapper.swift
//  WidgetBox
//
//  Created by Ali on 9/2/21.
//

import Foundation
import GoogleMobileAds

public protocol NativeAdWrapperDelegate:NSObject {
    func nativeAd(willShown ad:NativeAdWrapper)
    func nativeAd(willDismiss ad:NativeAdWrapper)
    func nativeAd(didDismiss ad:NativeAdWrapper)
    func nativeAd(didRemoveFromRepository ad:NativeAdWrapper)
    func nativeAd(onError ad:NativeAdWrapper,error:Error?)
    func nativeAd(didExpire ad:NativeAdWrapper)
    func nativeAd(didClicked ad:NativeAdWrapper)
    func nativeAd(didRecordImpression ad:NativeAdWrapper)
    func nativeAd(_ ad:NativeAdWrapper,isMuted:Bool)
}
extension NativeAdWrapperDelegate {
  public func nativeAd(willShown ad:NativeAdWrapper){}
  public func nativeAd(willDismiss ad:NativeAdWrapper){}
  public func nativeAd(didDismiss ad:NativeAdWrapper){}
  public func nativeAd(didRemoveFromRepository ad:NativeAdWrapper){}
  public func nativeAd(onError ad:NativeAdWrapper,error:Error?){}
  public func nativeAd(didExpire ad:NativeAdWrapper){}
  public func nativeAd(didClicked ad:NativeAdWrapper){}
  public func nativeAd(didRecordImpression ad:NativeAdWrapper){}
  public func nativeAd(_ ad:NativeAdWrapper,isMuted:Bool){}
}

public class NativeAdWrapper:NSObject{
   public private(set) var repoConfig:RepoConfig
   public private(set) var loadedAd: GADNativeAd
   public private(set) var loadedDate:TimeInterval = Date().timeIntervalSince1970
   public private(set) var showCount:Int = 0
   public private(set) var referenceCount:Int = 0
   public private(set) weak var owner:NativeAdsRepository? = nil
   public  weak var delegate:NativeAdWrapperDelegate? = nil
    
   private weak var timer:Timer? = nil
    
    init(loadedAd: GADNativeAd,owner:NativeAdsRepository) {
        self.repoConfig = owner.config
        self.loadedAd = loadedAd
        super.init()
        self.owner = owner
        self.loadedAd.delegate = self
        startExpireInterval()
    }
    private func startExpireInterval(){
        timer = Timer.scheduledTimer(withTimeInterval: repoConfig.expireIntervalTime*1000,
                                          repeats: false,
                                          block: {[weak self]  timer in
            
            guard let self = self else {return}
            print("Native Ad was expire")
            self.delegate?.nativeAd(didExpire: self)
            self.owner?.nativeAd(didExpire: self)
        })
    }
    deinit {
        timer?.invalidate()
        timer = nil
        print("deinit","Native Ad")
    }
}
extension NativeAdWrapper{
    static func == (lhs: NativeAdWrapper, rhs: NativeAdWrapper) -> Bool{
        lhs.loadedAd == rhs.loadedAd
    }
}

extension NativeAdWrapper: GADNativeAdDelegate {
    
    public func nativeAdDidRecordClick(_ nativeAd: GADNativeAd) {
        print("NativeAd","RecordClick")
        delegate?.nativeAd(didClicked: self)
    }
    public func nativeAdDidDismissScreen(_ nativeAd: GADNativeAd) {
        print("NativeAd","DidDismiss")
        delegate?.nativeAd(didDismiss: self)
        owner?.nativeAd(didDismiss: self)
    }
    public func nativeAdWillPresentScreen(_ nativeAd: GADNativeAd) {
        print("NativeAd","AdWillPresent")
        self.showCount += 1
        delegate?.nativeAd(willShown: self)
    }
    public func nativeAdWillDismissScreen(_ nativeAd: GADNativeAd) {
        print("NativeAd","AdWillDismiss")
        delegate?.nativeAd(willDismiss: self)
    }
    public func nativeAdDidRecordImpression(_ nativeAd: GADNativeAd) {
        print("NativeAd","RecordImpression")
        delegate?.nativeAd(didRecordImpression: self)
    }
    public func nativeAdIsMuted(_ nativeAd: GADNativeAd) {
        print("NativeAd","IsMuted")
        delegate?.nativeAd(self,isMuted: true)
    }
}
