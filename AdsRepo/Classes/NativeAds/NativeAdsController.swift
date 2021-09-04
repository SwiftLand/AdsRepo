//
//  NativeAdsController.swift
//  WidgetBox
//
//  Created by Ali on 9/2/21.
//

import Foundation
import GoogleMobileAds


class NativeAdsController:NSObject{
    static let `default` = NativeAdsController()
    var repoConfig:RepoConfig? = nil{
        didSet{
            if repoConfig != nil {
                configAdLoader()
            }else{
                adLoader = nil
            }
        }
    }
    var isConfig:Bool{return repoConfig != nil}
    var adsRepo:[NativeAdWrapper] = []
    var isDisable:Bool = false
    var delegate:AdsRepoDelegate? = nil
    private var adLoader: GADAdLoader?
    private var onCompleteLoading:(()->Void)? = nil
    
    
    init(delegate:AdsRepoDelegate? = nil){
        super.init()
        self.delegate = delegate
    }
    
   private func configAdLoader(){
        // Create multiple ads ad loader options
        guard let repoConfig = repoConfig else {return}
        var multipleAdsAdLoaderOptions: [GADMultipleAdsAdLoaderOptions]? {
                let multiAdOption = GADMultipleAdsAdLoaderOptions()
                multiAdOption.numberOfAds = repoConfig.totalSize
            
              return [multiAdOption]
            
        }
        // Create GADAdLoader
        adLoader = GADAdLoader(
            adUnitID: repoConfig.AdUnitId,
            rootViewController: nil,
            adTypes: [.native],
            options: multipleAdsAdLoaderOptions
        )

        // Set the GADAdLoader delegate
        adLoader?.delegate = self
    }
    
    func fillRepoAds(){
        guard !isDisable else {return}
        guard let repoConfig = repoConfig else {return}
        guard adsRepo.count<repoConfig.totalSize else {return}
        adLoader?.load(GADRequest())
    }
    
    func loadAd(onAdReay:@escaping ((NativeAdWrapperProtocol?)->Void)){
        if let lessShowCount = adsRepo.min(by: {$0.showCount<$1.showCount}) {
            onAdReay(lessShowCount)
        }
        if adLoader?.isLoading ?? false{
            fillRepoAds()
        }
        onAdReay(nil)
    }
}

extension NativeAdsController: GADNativeAdLoaderDelegate {

    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADNativeAd) {
        guard let repoConfig = repoConfig else {return}
        let adWrapper = NativeAdWrapper(repoConfig: repoConfig, loadedAd: nativeAd)
        adsRepo.append(adWrapper)
        delegate?.didReceiveNativeAds()
    }

    func adLoaderDidFinishLoading(_ adLoader: GADAdLoader) {
        delegate?.didFinishLoadingNativeAds()
    }

    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
        delegate?.didFailToReceiveNativeAdWithError(error)
    }
}

