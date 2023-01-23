//
//  IntesetinalAdLoader.swift
//  AdsRepo
//
//  Created by Ali on 1/20/23.
//

import Foundation
import GoogleMobileAds

public class InterstitialAdLoader:AdLoaderProtocol{
    
    public var state: AdLoaderState = .waiting
    public var request:GADRequest = GADRequest()
    public var config:AdRepositoryConfig
    public weak var delegate:(any AdLoaderDelegate)?
    
    private var count = 0
    
    required public init(config: AdRepositoryConfig) {
        self.config = config
    }
    
    
    public func load(count:Int){
        guard state == .waiting else {return}
        state = .loading
        self.count = count
        for _ in 0..<count{
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
    
    private func handlerError(error:Error?){
        print("Interstitial Ad failed to load with error: \(String(describing: error?.localizedDescription))")
        self.state = .waiting
        self.delegate?.adLoader(didFinishLoad: self, withError: error)
    }
    
    private func fulfill(ad: GADInterstitialAd){
        
        let adWrapper = InterstitialAdWrapper(ad, config: config)
        delegate?.adLoader(self, didReceive: adWrapper)
        count -= 1
        if count == 0 {
            delegate?.adLoader(didFinishLoad: self, withError: nil)
        }
        state = .waiting
    }

}
