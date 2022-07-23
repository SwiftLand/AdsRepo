//
//  NativeAdsController.swift
//  WidgetBox
//
//  Created by Ali on 9/2/21.
//

import Foundation
import GoogleMobileAds

public protocol NativeAdsControllerDelegate:NSObject{
    func nativeAdsControl(didReceive repo:NativeAdsController)
    func nativeAdsControl(didFinishLoading repo:NativeAdsController,error:Error?)
}
extension NativeAdsControllerDelegate{
    public func nativeAdsControl(didReceive repo:NativeAdsController){}
    public func nativeAdsControl(didFinishLoading repo:NativeAdsController,error:Error?){}
}
public class NativeAdsController:NSObject,AdsRepoProtocol{
    
    private var errorHandler:ErrorHandler
    public private(set) var config:RepoConfig
    private weak var rootVC:UIViewController? = nil
    public private(set) var adsRepo:[NativeAdWrapper] = []
    public var autoFill:Bool = true
    
    public  var isLoading:Bool {
        adLoader?.isLoading ?? false
    }
    
    public  var isDisable:Bool = false{
        didSet{
            if isDisable{
                adsRepo.removeAll()
                stopLoading()
            }else{
                fillRepoAds()
            }
        }
    }
    weak var delegate:NativeAdsControllerDelegate? = nil
    private var adLoader: GADAdLoader?
    private var onCompleteLoading:(()->Void)? = nil
    
    
    public init(config:RepoConfig,
                errorHandlerConfig:ErrorHandlerConfig? = nil,
                delegate:NativeAdsControllerDelegate? = nil){
        
        self.delegate = delegate
        self.config = config
        self.errorHandler = ErrorHandler(config: errorHandlerConfig)
        super.init()
    }
    
    public func config(_ config:RepoConfig,rootVC:UIViewController? = nil){
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
    
    public func fillRepoAds(){
        guard !isDisable else {return}
        guard adsRepo.count<config.repoSize else {return}
        
        guard !(adLoader?.isLoading ?? false) else{return}
        
        configAdLoader()
        adLoader?.load(GADRequest())
    }
    
    public func loadAd(loadFromRepo:@escaping ((NativeAdWrapper?)->Void)){
        
        removeExpireAds()
        guard adsRepo.count>0 else {
            loadFromRepo(nil)
            fillRepoAds()
            return
        }
        
      loadFromRepo(adsRepo.min(by: {$0.showCount<$1.showCount}))
      if adsRepo.count<config.repoSize {
           fillRepoAds()
       }
    }
    
    public func removeExpireAds(){
        let now = Date().timeIntervalSince1970
        adsRepo.removeAll(where: {now-$0.loadedDate > config.expireIntervalTime})
    }
    public func stopLoading() {
        errorHandler.cancel()
        adLoader?.delegate = nil
        adLoader = nil
    }
}
extension NativeAdsController {
    func nativeAd(didDismiss ad: NativeAdWrapper){
        if let threshold = config.showCountThreshold,ad.showCount>=threshold{
            adsRepo.removeAll(where: {$0 == ad})
            if autoFill {
                fillRepoAds()
            }
        }
    }
    func nativeAd(didExpire ad: NativeAdWrapper){
        adsRepo.removeAll(where: {$0 == ad})
        if autoFill {
            fillRepoAds()
        }
    }
}

extension NativeAdsController:GADNativeAdLoaderDelegate{
    public func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADNativeAd) {
        print("Native AdLoader","did Receive ads")
        adsRepo.append(NativeAdWrapper(loadedAd: nativeAd,owner: self))
        delegate?.nativeAdsControl(didReceive: self)
        AdsRepo.default.nativeAdsControl(didReceive: self)
    }
    
    public func adLoaderDidFinishLoading(_ adLoader: GADAdLoader) {
        print("Native AdLoader","DidFinishLoading")
        delegate?.nativeAdsControl(didFinishLoading:self,error:nil)
        AdsRepo.default.nativeAdsControl(didFinishLoading:self,error:nil)
    }
    
    public func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
        print("Native AdLoader","error:",error)
        if errorHandler.isRetryAble(error: error),!isLoading{
            if autoFill {
                fillRepoAds()
            }
        }else{
            delegate?.nativeAdsControl(didFinishLoading:self, error: error)
            AdsRepo.default.nativeAdsControl(didFinishLoading:self, error: error)
        }
    }
}
