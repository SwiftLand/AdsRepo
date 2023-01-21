//
//  AdLoaderCreatorMock.swift
//  AdsRepo-Unit-Tests
//
//  Created by Ali on 8/10/22.
//

import Foundation
import GoogleMobileAds
@testable import AdsRepo
class AdLoaderCreatorMock:AdLoaderFactoryProtocol{
    
    var fakeAd = FakeNativeAdMock()
    var isLoading:Bool = false
    var callCount:Int = 0
    var eachTimeAdRequestCount:[Int?] = []
   
    
    var isAllRequestsValied:Bool {
        for i in eachTimeAdRequestCount {
            guard let i = i,i>0 else {return false}
        }
        return true
    }
    
    func create(adUnitId: String, rootViewController: UIViewController?, adLoaderOptions: [GADAdLoaderOptions]?, adTypes: [GADAdLoaderAdType]?) -> GADAdLoader {
        // Create GADAdLoader
        let adLoader = GADAdLoaderMock(adUnitID: adUnitId, rootViewController: rootViewController,
                                       adTypes: adTypes ?? [.native], options: adLoaderOptions)
        callCount += 1
        adLoader.loadClosure = {[unowned self] request in
            
            let multiOption = adLoaderOptions?.first(where: {$0 is GADMultipleAdsAdLoaderOptions}) as? GADMultipleAdsAdLoaderOptions
            
            eachTimeAdRequestCount.append( multiOption?.numberOfAds)
            
            let requetsCount = multiOption?.numberOfAds ?? 0
            let total = (requetsCount>5 ? 5 : requetsCount)
            
            for i in 1...total{
                (adLoader.delegate as? GADNativeAdLoaderDelegate)?.adLoader(adLoader, didReceive: self.fakeAd)
                if i == total {
                    adLoader.delegate?.adLoaderDidFinishLoading?(adLoader)
                }
            }
            
        }
        adLoader.isLoading = isLoading
        return adLoader
    }
}
