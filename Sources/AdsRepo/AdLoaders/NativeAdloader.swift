//
//  Adloader.swift
//  AdsRepo
//
//  Created by Ali on 1/20/23.
//

import Foundation
import GoogleMobileAds

public class NativeAdLoader:NSObject,AdLoaderProtocol{
    
    public typealias AdWrapperType = GADNativeAdWrapper
    
    public var state: AdLoaderState = .waiting
    public var config:AdRepositoryConfig
    public var request:GADRequest = GADRequest()
    
    public var notifyRepositoryDidReceiveAd: ((AdWrapperType) -> ())?
    public var notifyRepositoryDidFinishLoad: ((Error?) -> ())?
    
    private weak var rootVC:UIViewController? = nil
    private var options:[GADAdLoaderOptions]? = nil
    private var adTypes:[GADAdLoaderAdType]? = nil
    private var nativeAdLoader:GADAdLoader!
    private var receiveddError:Error? = nil
    
    internal var Loader = GADAdLoader.self
    
    required public init(config: AdRepositoryConfig) {
        self.config = config
    }
    
    public func load(count:Int){
        state = .loading
        
        var options = options ?? []
        let adTypes = adTypes ?? [.native]
        let vc = rootVC ?? UIApplication.shared.keyWindow?.rootViewController
        
        //multiAdOption have to control from repository
        options.removeAll(where:{$0 is GADMultipleAdsAdLoaderOptions})
        let multiAdOption = GADMultipleAdsAdLoaderOptions()
        multiAdOption.numberOfAds = count
        options.append(multiAdOption)
        
        nativeAdLoader = Loader.init(
            adUnitID:config.adUnitId,
            rootViewController: vc,
            adTypes: adTypes,
            options: options
        )
        
        nativeAdLoader.delegate = self
        nativeAdLoader.load(request)
    }
    
    public func updateLoader(adTypes:[GADAdLoaderAdType]?,
                             options:[GADAdLoaderOptions]?,
                             rootVC:UIViewController?){
        self.adTypes = adTypes
        self.options = options
        self.rootVC = rootVC
    }
    
    public func set(adTypes:[GADAdLoaderAdType]?){
        self.adTypes = adTypes
    }
    
    public func set(options:[GADAdLoaderOptions]?){
        self.options = options
    }
    
    public func set(rootViewController rootVC:UIViewController?){
        self.rootVC = rootVC
    }
    
}

extension NativeAdLoader:GADNativeAdLoaderDelegate{
    
    public  func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADNativeAd) {
        notifyRepositoryDidReceiveAd?(GADNativeAdWrapper(loadedAd: nativeAd, config: config))
    }
    
    public func adLoaderDidFinishLoading(_ adLoader: GADAdLoader) {
        state = .waiting
        let error = receiveddError
        receiveddError = nil
        notifyRepositoryDidFinishLoad?(error)
    }
    
    public func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
        receiveddError = error
    }
}
