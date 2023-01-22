//
//  AdLoaderCreator.swift
//  AdsRepo-Unit-Tests
//
//  Created by Ali on 8/10/22.
//

import Foundation
import GoogleMobileAds

/// Used for `AdLoader` dependency injection
protocol AdLoaderFactoryProtocol{
    
     associatedtype AdWrapperType
    
     func create(config:AdRepositoryConfig,
                delegate:any AdLoaderDelegate,
                rootViewController:UIViewController?,
                adLoaderOptions:[GADAdLoaderOptions]?,
                adTypes:[GADAdLoaderAdType]?) -> AdLoaderProtocol
}

class AdLoaderFactory<AdWrapperType>:AdLoaderFactoryProtocol{

    func create(config:AdRepositoryConfig,
                delegate:any AdLoaderDelegate,
                rootViewController:UIViewController? = nil,
                adLoaderOptions:[GADAdLoaderOptions]? = nil,
                adTypes:[GADAdLoaderAdType]? = nil) -> AdLoaderProtocol {
        
        
        if AdWrapperType.self == InterstitialAdWrapper.self{
            return InterstitialAdLoader(config: config, delegate: delegate)
        }else if AdWrapperType.self == RewardedAdWrapper.self{
            return RewardedAdLoader(config: config, delegate: delegate)
        }else if  AdWrapperType.self == NativeAdWrapper.self{
            return NativeAdLoader(config: config, delegate: delegate)
        }else{
            fatalError("Not implemented")
        }
    }
}
