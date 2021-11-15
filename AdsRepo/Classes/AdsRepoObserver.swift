//
//  Observer.swift
//  AdMobManager
//
//  Created by Ali on 9/3/21.
//

import Foundation

public protocol AdsRepoDelegate {
    
    func bannerAd(didReady ad:BannerAdWrapper)
    func bannerAd(didShown ad:BannerAdWrapper)
    func bannerAd(willDismiss ad:BannerAdWrapper)
    func bannerAd(didDismiss ad:BannerAdWrapper)
    func bannerAd(onError ad:BannerAdWrapper,error:Error?)
    func bannerAd(didExpire ad:BannerAdWrapper)
    func didReceiveBannerAds()
    func didFinishLoadingBannerAds()
    func didFailToReceiveBannerAdWithError(_ error: Error)
    
    
    func adsRepoDelegate(didReady ad:RewardAdWrapper)
    func adsRepoDelegate(didOpen ad:RewardAdWrapper)
    func adsRepoDelegate(willClose ad:RewardAdWrapper)
    func adsRepoDelegate(didClose ad:RewardAdWrapper)
    func adsRepoDelegate(onError ad:RewardAdWrapper,error:Error?)
    func adsRepoDelegate(didReward ad:RewardAdWrapper,reward:Double)
    func adsRepoDelegate(didExpire ad:RewardAdWrapper)
    
    func adsRepoDelegate(didReady ad:InterstitialAdWrapper)
    func adsRepoDelegate(didOpen ad:InterstitialAdWrapper)
    func adsRepoDelegate(willClose ad:InterstitialAdWrapper)
    func adsRepoDelegate(didClose ad:InterstitialAdWrapper)
    func adsRepoDelegate(onError ad:InterstitialAdWrapper,error:Error?)
    func adsRepoDelegate(didExpire ad:InterstitialAdWrapper)
    
    func didReceiveNativeAds()
    func didFinishLoadingNativeAds()
    func didFailToReceiveNativeAdWithError(_ error: Error)
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
public extension AdsRepoDelegate {
    func bannerAd(didReady ad:BannerAdWrapper){}
    func bannerAd(didShown ad:BannerAdWrapper){}
    func bannerAd(willDismiss ad:BannerAdWrapper){}
    func bannerAd(didDismiss ad:BannerAdWrapper){}
    func bannerAd(onError ad:BannerAdWrapper,error:Error?){}
    func bannerAd(didExpire ad:BannerAdWrapper){}
    func didReceiveBannerAds(){}
    func didFinishLoadingBannerAds(){}
    func didFailToReceiveBannerAdWithError(_ error: Error){}
    
    func adsRepoDelegate(didReady ad:RewardAdWrapper){}
    func adsRepoDelegate(didOpen ad:RewardAdWrapper){}
    func adsRepoDelegate(willClose ad:RewardAdWrapper){}
    func adsRepoDelegate(didClose ad:RewardAdWrapper){}
    func adsRepoDelegate(onError ad:RewardAdWrapper,error:Error?){}
    func adsRepoDelegate(didReward ad:RewardAdWrapper,reward:Double){}
    func adsRepoDelegate(didExpire ad:RewardAdWrapper){}
    
    func adsRepoDelegate(didReady ad:InterstitialAdWrapper){}
    func adsRepoDelegate(didOpen ad:InterstitialAdWrapper){}
    func adsRepoDelegate(willClose ad:InterstitialAdWrapper){}
    func adsRepoDelegate(didClose ad:InterstitialAdWrapper){}
    func adsRepoDelegate(onError ad:InterstitialAdWrapper,error:Error?){}
    func adsRepoDelegate(didExpire ad:InterstitialAdWrapper){}
    
    func didReceiveNativeAds(){}
    func didFinishLoadingNativeAds(){}
    func didFailToReceiveNativeAdWithError(_ error: Error){}
    func nativeAd(didReady ad:NativeAdWrapper){}
    func nativeAd(willShown ad:NativeAdWrapper){}
    func nativeAd(willDismiss ad:NativeAdWrapper){}
    func nativeAd(didDismiss ad:NativeAdWrapper){}
    func nativeAd(onError ad:NativeAdWrapper,error:Error?){}
    func nativeAd(didExpire ad:NativeAdWrapper){}
    func nativeAd(didClicked ad:NativeAdWrapper){}
    func nativeAd(didRecordImpression ad:NativeAdWrapper){}
    func nativeAd(_ ad:NativeAdWrapper,isMuted:Bool){}
}

public protocol AdsRepoObserver:AnyObject,AdsRepoDelegate {
    var observerId:String{get}
}

protocol AdsRepoObservable {
    var observers : [Weak<AdsRepoObserver>] { get set }
    func addObserver(observer: AdsRepoObserver)
    func removeObserver(observer: AdsRepoObserver)
    func removeObserver(observerId: String)
}

struct Weak<T> {
    var value: T? { provider() }
    private let provider: () -> T?

    init(_ object: T) {
        // Any Swift value can be "promoted" to an AnyObject, however,
        // that doesn't automatically turn it into a reference.
        let reference = object as AnyObject

        provider = { [weak reference] in
            reference as? T
        }
    }
}
