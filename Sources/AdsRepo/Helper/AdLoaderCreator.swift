//
//  AdLoaderCreator.swift
//  AdsRepo-Unit-Tests
//
//  Created by Ali on 8/10/22.
//

import Foundation
import GoogleMobileAds

protocol AdLoaderCreatorProtocol{
    func create(adUnitId:String,
                rootViewController:UIViewController?,
                adLoaderOptions:[GADAdLoaderOptions]?,
                adTypes:[GADAdLoaderAdType]?) -> GADAdLoader
}

class AdLoaderCreator:AdLoaderCreatorProtocol{
    
    func create(adUnitId:String,
                rootViewController:UIViewController? = nil,
                adLoaderOptions:[GADAdLoaderOptions]? = nil,
                adTypes:[GADAdLoaderAdType]? = nil) -> GADAdLoader {
        
        // Create GADAdLoader
        let adLoader = GADAdLoader(
            adUnitID:adUnitId,
            rootViewController: rootViewController,
            adTypes: adTypes ?? [.native],
            options: adLoaderOptions
        )
        return adLoader
    }
}
