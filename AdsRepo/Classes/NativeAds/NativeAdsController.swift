//
//  NativeAdsController.swift
//  WidgetBox
//
//  Created by Ali on 9/2/21.
//

import Foundation
import GoogleMobileAds

protocol NativeAdsControllerDelegate:NativeAdWrapperDelegate {
    func didReceiveNativeAds()
    func didFinishLoadingNativeAds()
    func didFailToReceiveNativeAdWithError(_ error: Error)
}

class NativeAdsController:NSObject{
  
    static let `default` = NativeAdsController()
    private(set) var repoConfig:RepoConfig? = nil
    var isConfig:Bool{return repoConfig != nil}
    private weak var rootVC:UIViewController? = nil
    private(set) var adsRepo:[NativeAdWrapper] = []
    var isDisable:Bool = false{
        didSet{
            if isDisable{
                adsRepo.removeAll()
                stopLoading()
            }else{
                fillRepoAds()
            }
        }
    }
    var delegate:NativeAdsControllerDelegate? = nil
    private var adLoader: GADAdLoader?
    private var onCompleteLoading:(()->Void)? = nil
    
    
    init(delegate:NativeAdsControllerDelegate? = nil){
        super.init()
        self.delegate = delegate
    }
    
    func config(_ config:RepoConfig? = nil,rootVC:UIViewController? = nil){
        // Create multiple ads ad loader options
        self.rootVC = rootVC
        guard let config = config else {
            self.repoConfig = nil
            stopLoading()
            return
        }
        self.repoConfig = config
        configAdLoader()
    }
    
    private func configAdLoader(){
        guard let repoConfig = repoConfig else {return}
        var adLoaderOptions: [GADAdLoaderOptions]? {
            let multiAdOption = GADMultipleAdsAdLoaderOptions()
            multiAdOption.numberOfAds = repoConfig.repoSize - adsRepo.count
            
            let videoOption = GADVideoOptions()
            videoOption.startMuted = true
            videoOption.customControlsRequested = true
            videoOption.clickToExpandRequested = true
            return [multiAdOption,videoOption]
        }
        
        // Create GADAdLoader
        adLoader = GADAdLoader(
            adUnitID:repoConfig.adUnitId,
            rootViewController: rootVC,
            adTypes: [.native],
            options: adLoaderOptions
        )
        
        // Set the GADAdLoader delegate
        adLoader?.delegate = self
    }
    func fillRepoAds(){
        guard !isDisable else {return}
        guard let repoConfig = repoConfig else {return}
        guard adsRepo.count<repoConfig.repoSize else {return}
        
        guard !(adLoader?.isLoading ?? false) else{return}
        
        configAdLoader()
        adLoader?.load(GADRequest())
    }
    
    func loadAd(onAdReay:@escaping ((NativeAdWrapper?)->Void)){
        guard let repoConfig = repoConfig else {return}
        
        let now = Date().timeIntervalSince1970
        adsRepo.removeAll(where: {now-$0.loadedDate > repoConfig.expireIntervalTime})
        
        guard adsRepo.count > 0 else {
            onAdReay(nil)
            fillRepoAds()
            return
        }
        
        if let lessShowCount = adsRepo.min(by: {$0.showCount<$1.showCount}) {
            onAdReay(lessShowCount)
        }
        
        if adsRepo.count<repoConfig.repoSize {
            fillRepoAds()
        }
    }
    
    func stopLoading() {
        adLoader?.delegate = nil
        adLoader = nil
    }
}

extension NativeAdsController: GADNativeAdLoaderDelegate {
    
    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADNativeAd) {
        guard let repoConfig = repoConfig else {return}
        adsRepo.append(NativeAdWrapper(repoConfig: repoConfig, loadedAd: nativeAd,owner: self))
        print("Native AdLoader","did Receive ads")
        delegate?.didReceiveNativeAds()
    }
    
    func adLoaderDidFinishLoading(_ adLoader: GADAdLoader) {
        print("Native AdLoader","DidFinishLoading")
        delegate?.didFinishLoadingNativeAds()
    }
    
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
        print("Native AdLoader","error:",error)
        delegate?.didFailToReceiveNativeAdWithError(error)
    }
    
}
extension NativeAdsController: NativeAdWrapperDelegate{

    func nativeAd(didReady ad: NativeAdWrapper) {
        delegate?.nativeAd(didReady:ad)
    }
    
    func nativeAd(willShown ad: NativeAdWrapper) {
        delegate?.nativeAd(willShown:ad)
    }
    
    func nativeAd(willDismiss ad: NativeAdWrapper) {
        delegate?.nativeAd(willDismiss:ad)
    }
    
    func nativeAd(didDismiss ad: NativeAdWrapper) {
        delegate?.nativeAd(didDismiss:ad)
        if let threshold = repoConfig?.showCountThreshold,ad.showCount>=threshold{
            adsRepo.removeAll(where: {$0 == ad})
            fillRepoAds()
        }
    }
    
    func nativeAd(onError ad: NativeAdWrapper, error: Error?) {//<- handle from adloader
        delegate?.nativeAd(onError:ad,error:error)
    }
    
    func nativeAd(didExpire ad: NativeAdWrapper) {
        print("Native didExpire",ad)
        adsRepo.removeAll(where: {$0 == ad})
        delegate?.nativeAd(didExpire: ad)
        fillRepoAds()
    }
    
    func nativeAd(didClicked ad:NativeAdWrapper){
        delegate?.nativeAd(didClicked:ad)
    }
    func nativeAd(didRecordImpression ad:NativeAdWrapper){
        delegate?.nativeAd(didRecordImpression:ad)
    }
    func nativeAd(_ ad:NativeAdWrapper,isMuted:Bool){
        delegate?.nativeAd(ad,isMuted:isMuted)
    }
}
