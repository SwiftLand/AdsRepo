//
//  NativeAdsController.swift
//  WidgetBox
//
//  Created by Ali on 9/2/21.
//

import Foundation
import GoogleMobileAds

public protocol NativeAdsControllerDelegate:NSObject{
    func nativeAdsControl(didReceive config:RepoConfig)
    func nativeAdsControl(didFinishLoading config:RepoConfig,error:Error?)
}
extension NativeAdsControllerDelegate{
    func nativeAdsControl(didReceive config:RepoConfig){}
    func nativeAdsControl(didFinishLoading config:RepoConfig,error:Error?){}
}
public class NativeAdsController:NSObject,AdsRepoProtocol{
   
    private var errorHandler:ErrorHandler
    private(set) var config:RepoConfig
    private weak var rootVC:UIViewController? = nil
    private(set) var adsRepo:[NativeAdWrapper] = []
    
    var isLoading:Bool {
        adLoader?.isLoading ?? false
    }
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
    
    
    init(config:RepoConfig,
         errorHandlerConfig:ErrorHandlerConfig? = nil,
         delegate:NativeAdsControllerDelegate? = nil){
        
        self.delegate = delegate
        self.config = config
        self.errorHandler = ErrorHandler(config: errorHandlerConfig)
        super.init()
    }
    
    func config(_ config:RepoConfig,rootVC:UIViewController? = nil){
        // Create multiple ads ad loader options
        self.rootVC = rootVC
        self.config = config
        configAdLoader()
    }
    
    private func configAdLoader(){
        var adLoaderOptions: [GADAdLoaderOptions]? {
            let multiAdOption = GADMultipleAdsAdLoaderOptions()
            multiAdOption.numberOfAds = config.repoSize - adsRepo.count
            
            let videoOption = GADVideoOptions()
            videoOption.startMuted = true
            videoOption.customControlsRequested = true
            videoOption.clickToExpandRequested = true
            return [multiAdOption,videoOption]
        }
        
        // Create GADAdLoader
        adLoader = GADAdLoader(
            adUnitID:config.adUnitId,
            rootViewController: rootVC,
            adTypes: [.native],
            options: adLoaderOptions
        )
        // Set the GADAdLoader delegate
        adLoader?.delegate = self
    }
    
    func fillRepoAds(){
        guard !isDisable else {return}
        guard adsRepo.count<config.repoSize else {return}
        
        guard !(adLoader?.isLoading ?? false) else{return}
        
        configAdLoader()
        adLoader?.load(GADRequest())
    }
    
    func loadAd(onAdReay:@escaping ((NativeAdWrapper?)->Void)){
        
        let now = Date().timeIntervalSince1970
        adsRepo.removeAll(where: {now-$0.loadedDate > config.expireIntervalTime})
        
        guard adsRepo.count > 0 else {
            onAdReay(nil)
            fillRepoAds()
            return
        }
        
        if let lessShowCount = adsRepo.min(by: {$0.showCount<$1.showCount}) {
            onAdReay(lessShowCount)
        }
        
        if adsRepo.count<config.repoSize {
            fillRepoAds()
        }
    }
    func stopLoading() {
        errorHandler.cancel()
        adLoader?.delegate = nil
        adLoader = nil
    }
}
extension NativeAdsController {
    func nativeAd(didDismiss ad: NativeAdWrapper){
        if let threshold = config.showCountThreshold,ad.showCount>=threshold{
            adsRepo.removeAll(where: {$0 == ad})
            fillRepoAds()
        }
    }
    func nativeAd(didExpire ad: NativeAdWrapper){
        adsRepo.removeAll(where: {$0 == ad})
        fillRepoAds()
    }
}

extension NativeAdsController:GADNativeAdLoaderDelegate{
    public func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADNativeAd) {
        print("Native AdLoader","did Receive ads")
        adsRepo.append(NativeAdWrapper(loadedAd: nativeAd,owner: self))
        delegate?.nativeAdsControl(didReceive: config)
        AdsRepo.default.nativeAdsControl(didReceive: config)
    }
    
    public func adLoaderDidFinishLoading(_ adLoader: GADAdLoader) {
        print("Native AdLoader","DidFinishLoading")
        delegate?.nativeAdsControl(didFinishLoading:config,error:nil)
        AdsRepo.default.nativeAdsControl(didFinishLoading:config,error:nil)
    }
    
    public func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
        print("Native AdLoader","error:",error)
        if errorHandler.isRetryAble(error: error),!isLoading{
            fillRepoAds()
        }else{
            delegate?.nativeAdsControl(didFinishLoading:config, error: error)
            AdsRepo.default.nativeAdsControl(didFinishLoading:config, error: error)
        }
    }
}
