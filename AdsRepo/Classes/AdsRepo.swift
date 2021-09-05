//
//  AdMobManager.swift
//  AdMobManager
//
//  Created by Ali on 9/2/21.
//

import Foundation
import GoogleMobileAds


public class AdsRepo:NSObject{
    public static let `default` = AdsRepo()
    var observers:[Weak<AdsRepoObserver>] = []
 
 
    private override init() {}
    
    public func config(rootVC:UIViewController? = nil,
                       interstitialConfig interstitial:RepoConfig? = nil,
                       rewardConfig reward:RepoConfig? = nil,
                       nativeConfig native:RepoConfig? = nil){
        
        if let reward = reward{
            configRewardAd(reward)
        }
        if let interstitial = interstitial {
            configInterstitialAd(interstitial)
        }
        if let native = native{
            configNativeAd(native,rootVC:rootVC)
        }
      
    }
    public func isDisable(_ state:Bool){
        RewardAdsController.default.isDisable = true
        InterstitialAdsController.default.isDisable = true
        NativeAdsController.default.isDisable = true
    }
    public func configRewardAd(_ config:RepoConfig){
        RewardAdsController.default.repoConfig = config
        RewardAdsController.default.delegate = self
    }
    public func configInterstitialAd(_ config:RepoConfig){
        InterstitialAdsController.default.repoConfig = config
        InterstitialAdsController.default.delegate = self
    }
    public  func configNativeAd(_ config:RepoConfig,rootVC:UIViewController? = nil ){
        NativeAdsController.default.config(config,rootVC: rootVC)
        NativeAdsController.default.delegate = self
    }
    
    public func loadAds(){
        RewardAdsController.default.fillRepoAds()
        InterstitialAdsController.default.fillRepoAds()
        NativeAdsController.default.fillRepoAds()
    }
    
    public func hasReadyRewardAd(vc:UIViewController) -> Bool{
        return RewardAdsController.default.hasReadyAd(vc: vc)
    }
    public func hasReadyInterstitialAd(vc:UIViewController) -> Bool{
        return InterstitialAdsController.default.hasReadyAd(vc: vc)
    }
    
    public func showRewardAd(vc:UIViewController){
        RewardAdsController.default.presentAd(vc: vc)
    }
    public func showInterstitialAd(vc:UIViewController){
        InterstitialAdsController.default.presentAd(vc: vc)
    }
    public func loadNativeAd(onAdReay:@escaping ((NativeAdWrapperProtocol?)->Void)){
        NativeAdsController.default.loadAd(onAdReay: onAdReay)
    }
}

extension AdsRepo:AdsRepoDelegate{
  
    
    //rewardAds
    public  func adMobManagerDelegate(didReady ad:RewardAdWrapper){
        observers.forEach({$0.value?.adMobManagerDelegate(didReady: ad)})
    }
    public func adMobManagerDelegate(didOpen ad:RewardAdWrapper){
        observers.forEach({$0.value?.adMobManagerDelegate(didOpen: ad)})
    }
    public func adMobManagerDelegate(willClose ad:RewardAdWrapper){
        observers.forEach({$0.value?.adMobManagerDelegate(willClose: ad)})
    }
    public func adMobManagerDelegate(didClose ad:RewardAdWrapper){
        observers.forEach({$0.value?.adMobManagerDelegate(didClose: ad)})
    }
    public func adMobManagerDelegate(onError ad:RewardAdWrapper,error:Error?){
        observers.forEach({$0.value?.adMobManagerDelegate(onError: ad,error:error)})
    }
    public func adMobManagerDelegate(didReward ad:RewardAdWrapper,reward:Double){
        observers.forEach({$0.value?.adMobManagerDelegate(didReward: ad,reward:reward)})
    }
    
    //InterstitialAds
    public func adMobManagerDelegate(didReady ad:InterstitialAdWrapper){
        observers.forEach({$0.value?.adMobManagerDelegate(didReady: ad)})
    }
    public func adMobManagerDelegate(didOpen ad:InterstitialAdWrapper){
        observers.forEach({$0.value?.adMobManagerDelegate(didOpen: ad)})
    }
    public func adMobManagerDelegate(willClose ad:InterstitialAdWrapper){
        observers.forEach({$0.value?.adMobManagerDelegate(willClose: ad)})
    }
    public func adMobManagerDelegate(didClose ad:InterstitialAdWrapper){
        observers.forEach({$0.value?.adMobManagerDelegate(didClose: ad)})
    }
    public func adMobManagerDelegate(onError ad:InterstitialAdWrapper,error:Error?){
        observers.forEach({$0.value?.adMobManagerDelegate(onError: ad,error:error)})
    }
    
    //NativeAds
    public func didReceiveNativeAds() {
        observers.forEach({$0.value?.didReceiveNativeAds()})
    }
    
    public func didFinishLoadingNativeAds() {
        observers.forEach({$0.value?.didFinishLoadingNativeAds()})
    }
    
    public func didFailToReceiveNativeAdWithError(_ error: Error) {
        observers.forEach({$0.value?.didFailToReceiveNativeAdWithError(error)})
    }
}

extension AdsRepo:AdsRepoObservable{
   
    public func addObserver(observer: AdsRepoObserver) {
        observers.append(Weak(observer))
    }
    
    public func removeObserver(observer: AdsRepoObserver) {
        observers.removeAll(where: {$0.value?.observerId  == observer.observerId})
    }
    
    public func removeObserver(observerId: String) {
        observers.removeAll(where: {$0.value?.observerId == observerId})
    }
}
