//
//  IntesetinalAdLoader.swift
//  AdsRepo
//
//  Created by Ali on 1/20/23.
//

import Foundation
import GoogleMobileAds

class InterstitialAdLoader:AdLoaderProtocol{
    
    var state: AdLoaderState = .waiting
    
    var config:RepositoryConfig
    weak var delegate:AdLoaderDelegate?
    
    private var count = 0
    
    init(config: RepositoryConfig,delegate:AdLoaderDelegate) {
        self.config = config
        self.delegate = delegate
    }
    
    
    func load(adCount:Int){
        guard state == .waiting else {return}
        state = .loading
        count = adCount
        for _ in 0..<adCount{
            let request = GADRequest()
            GADInterstitialAd.load(withAdUnitID:config.adUnitId,
                                   request: request,completionHandler: {[weak self] (ad, error) in
                guard let self = self else{return}
                
                guard let ad = ad else {
                    self.handlerError(error:error)
                    return
                }
                
                self.fulfill(ad: ad)
            })
        }
    }
    
    func handlerError(error:Error?){
        print("Interstitial Ad failed to load with error: \(String(describing: error?.localizedDescription))")
        self.state = .waiting
        self.delegate?.adLoader(didFinishLoad: self, withError: error)
    }
    
    func fulfill(ad: GADInterstitialAd){
        
        let adWrapper = InterstitialAdWrapper(ad, config: config)
        delegate?.adLoader(self, didRecive: adWrapper)
        count -= 1
        if count == 0 {
            delegate?.adLoader(didFinishLoad: self, withError: nil)
        }
        state = .waiting
    }

}
