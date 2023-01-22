//
//  Adloader.swift
//  AdsRepo
//
//  Created by Ali on 1/20/23.
//

import Foundation
import GoogleMobileAds

class NativeAdLoader:NSObject,AdLoaderProtocol{
    
    var state: AdLoaderState = .waiting
    var config:AdRepositoryConfig
    var request:GADRequest = GADRequest()
    
    weak var delegate:AdLoaderDelegate?
    
    private var adLoader: GADAdLoader
    
    
    init(config: AdRepositoryConfig,delegate:AdLoaderDelegate) {
        self.config = config
        self.delegate = delegate
        
        //default loader
        adLoader = GADAdLoader(
            adUnitID:config.adUnitId,
            rootViewController: UIApplication.shared.keyWindow?.rootViewController,
            adTypes: [.native],
            options: []
        )
    }
    
    
    func load(adCount:Int){
        state = .loading
        adLoader.delegate = self
        adLoader.load(GADRequest())
    }
    
    func updateRequest(request:GADRequest){
        self.request = request
    }
    
    func updateLoader(adTypes:[GADAdLoaderAdType]? = nil,
                        options:[GADAdLoaderOptions]? = nil,
                        rootVC:UIViewController? = nil){
        
        let adLoaderOptions = options ?? []
        let vc = rootVC ?? UIApplication.shared.keyWindow?.rootViewController
        
        adLoader = GADAdLoader(
            adUnitID:config.adUnitId,
            rootViewController: vc,
            adTypes: adTypes ?? [.native],
            options: adLoaderOptions
        )
        
    }
    
}

extension NativeAdLoader:GADNativeAdLoaderDelegate{
    
    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADNativeAd) {
        delegate?.adLoader(self,didRecive:  NativeAdWrapper(loadedAd: nativeAd, config: config))
    }
    
    func adLoaderDidFinishLoading(_ adLoader: GADAdLoader) {
        print("Native AdLoader","DidFinishLoading")
        state = .waiting
        delegate?.adLoader(didFinishLoad: self,withError: nil)
    }
    
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
        state = .waiting
        delegate?.adLoader(didFinishLoad: self,withError: error)
    }
}

