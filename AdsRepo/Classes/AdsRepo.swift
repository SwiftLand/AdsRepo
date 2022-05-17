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
                       bannerConfig banner:RepoConfig? = nil,
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
    public func setTestDevices(deviceIds:[String]){
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = deviceIds
    }
    public func isDisable(_ state:Bool){
        RewardAdsController.default.isDisable = state
        InterstitialAdsController.default.isDisable = state
        NativeAdsController.default.isDisable = state
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
  
    private func loadAds(){
        self.loadAds(withATTCheck:true)
    }
    public func loadAds(withATTCheck:Bool = true){
        if withATTCheck {
            ATTHelper.request(){ (status) in
                RewardAdsController.default.fillRepoAds()
                InterstitialAdsController.default.fillRepoAds()
                NativeAdsController.default.fillRepoAds()
            }
        }else{
            RewardAdsController.default.fillRepoAds()
            InterstitialAdsController.default.fillRepoAds()
            NativeAdsController.default.fillRepoAds()

        }
    }
    
    public func requestRewardAdsIfNeed(){
        RewardAdsController.default.fillRepoAds()
    }
    public func requestInterstitialAdsIfNeed(){
        InterstitialAdsController.default.fillRepoAds()
    }
    
    public func hasAReadyRewardAd(vc:UIViewController) -> Bool{
        return RewardAdsController.default.hasReadyAd(vc: vc)
    }
    public func hasAReadyInterstitialAd(vc:UIViewController) -> Bool{
        return InterstitialAdsController.default.hasReadyAd(vc: vc)
    }
    
    public func showRewardAd(vc:UIViewController){
        RewardAdsController.default.presentAd(vc: vc)
    }
    public func showInterstitialAd(vc:UIViewController){
        InterstitialAdsController.default.presentAd(vc: vc)
    }
    public func loadNativeAd(onAdReay:@escaping ((NativeAdWrapper?)->Void)){
        NativeAdsController.default.loadAd(onAdReay: onAdReay)
    }
}

extension AdsRepo:RewardAdDelegate{
    func rewardAd(didReady ad: RewardAdWrapper) {
        observers.forEach({$0.value?.adsRepoDelegate(didReady: ad)})
    }
    
    func rewardAd(didOpen ad: RewardAdWrapper) {
        observers.forEach({$0.value?.adsRepoDelegate(didOpen: ad)})
    }
    
    func rewardAd(willClose ad: RewardAdWrapper) {
        observers.forEach({$0.value?.adsRepoDelegate(willClose: ad)})
    }
    
    func rewardAd(didClose ad: RewardAdWrapper) {
        observers.forEach({$0.value?.adsRepoDelegate(didClose: ad)})
    }
    
    func rewardAd(onError ad: RewardAdWrapper, error: Error?) {
        observers.forEach({$0.value?.adsRepoDelegate(onError: ad,error:error)})
    }
    
    func rewardAd(didReward ad: RewardAdWrapper, reward: Double) {
        observers.forEach({$0.value?.adsRepoDelegate(didReward: ad,reward:reward)})
     
    }
    func rewardAd(didExpire ad: RewardAdWrapper) {
        observers.forEach({$0.value?.adsRepoDelegate(didExpire: ad)})
    }
    
}
extension AdsRepo:InterstitialAdDelegate{
    func interstitialAd(didReady ad: InterstitialAdWrapper) {
        observers.forEach({$0.value?.adsRepoDelegate(didReady: ad)})
    }
    
    func interstitialAd(didOpen ad: InterstitialAdWrapper) {
        observers.forEach({$0.value?.adsRepoDelegate(didOpen: ad)})
    }
    
    func interstitialAd(willClose ad: InterstitialAdWrapper) {
        observers.forEach({$0.value?.adsRepoDelegate(willClose: ad)})
    }
    
    func interstitialAd(didClose ad: InterstitialAdWrapper) {
        observers.forEach({$0.value?.adsRepoDelegate(didClose: ad)})
    }
    
    func interstitialAd(onError ad: InterstitialAdWrapper, error: Error?) {
        observers.forEach({$0.value?.adsRepoDelegate(onError: ad,error:error)})
    }
    
    func interstitialAd(didExpire ad: InterstitialAdWrapper) {
        observers.forEach({$0.value?.adsRepoDelegate(didExpire: ad)})
    }
    
    
}
extension AdsRepo:NativeAdsControllerDelegate{
    
    public func didReceiveNativeAds() {
        observers.forEach({$0.value?.didReceiveNativeAds()})
    }
    public func didFinishLoadingNativeAds() {
        observers.forEach({$0.value?.didFinishLoadingNativeAds()})
    }
    public func didFailToReceiveNativeAdWithError(_ error: Error) {
        observers.forEach({$0.value?.didFailToReceiveNativeAdWithError(error)})
    }
    public func nativeAd(didReady ad:NativeAdWrapper){
        observers.forEach({$0.value?.nativeAd(didReady:ad)})
    }
    public func nativeAd(willShown ad:NativeAdWrapper){
        observers.forEach({$0.value?.nativeAd(willShown:ad)})
    }
    public func nativeAd(willDismiss ad:NativeAdWrapper){
        observers.forEach({$0.value?.nativeAd(willDismiss:ad)})
    }
    public func nativeAd(didDismiss ad:NativeAdWrapper){
        observers.forEach({$0.value?.nativeAd(didDismiss:ad)})
    }
    public func nativeAd(onError ad:NativeAdWrapper,error:Error?){
        observers.forEach({$0.value?.nativeAd(onError:ad,error:error)})
    }
    public func nativeAd(didExpire ad:NativeAdWrapper){
        observers.forEach({$0.value?.nativeAd(didExpire:ad)})
    }
    func nativeAd(didClicked ad:NativeAdWrapper){
        observers.forEach({$0.value?.nativeAd(didClicked:ad)})
    }
    func nativeAd(didRecordImpression ad:NativeAdWrapper){
        observers.forEach({$0.value?.nativeAd(didRecordImpression:ad)})
    }
    func nativeAd(_ ad:NativeAdWrapper,isMuted:Bool){
        observers.forEach({$0.value?.nativeAd(ad,isMuted:isMuted)})
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
