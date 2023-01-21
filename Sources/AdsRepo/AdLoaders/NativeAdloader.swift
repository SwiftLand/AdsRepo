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
    var config:RepositoryConfig
    weak var delegate:AdLoaderDelegate?
    
    private weak var rootVC:UIViewController? = nil
    private var adLoader: GADAdLoader?
    
    
    init(config: RepositoryConfig,delegate:AdLoaderDelegate) {
        self.config = config
        self.delegate = delegate
    }
    
    
    func load(adCount:Int){
        state = .loading
        adLoader?.load(GADRequest())
    }

    func configNativeAdLoader(adTypes:[GADAdLoaderAdType]? = nil,options:[GADAdLoaderOptions]? = nil,
                              rootVC:UIViewController? = nil){
        
        var adLoaderOptions = options ?? []
        
        //MARK: TODO
        //multiAdOption have to control from repository
//        adLoaderOptions.removeAll(where:{$0 is GADMultipleAdsAdLoaderOptions})
//        let multiAdOption = GADMultipleAdsAdLoaderOptions()
//        multiAdOption.numberOfAds = config.size - adsRepo.count
//        adLoaderOptions.append(multiAdOption)
//
        
        let vc = rootVC ?? UIApplication.shared.keyWindow?.rootViewController
        
        // Create GADAdLoader
        adLoader = GADAdLoader(
            adUnitID:config.adUnitId,
            rootViewController: vc,
            adTypes: adTypes ?? [.native],
            options: adLoaderOptions
        )
        
        // Set the GADAdLoader delegate
        adLoader?.delegate = self
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

