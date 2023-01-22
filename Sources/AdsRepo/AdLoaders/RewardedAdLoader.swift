//
//  RewardedAdLoader.swift
//  AdsRepo
//
//  Created by Ali on 1/20/23.
//

import Foundation
import GoogleMobileAds

class RewardedAdLoader:AdLoaderProtocol{
    
    var state: AdLoaderState = .waiting
    var request:GADRequest = GADRequest()
    var config:AdRepositoryConfig
    weak var delegate:AdLoaderDelegate?

    
    init(config: AdRepositoryConfig,delegate:AdLoaderDelegate) {
        self.config = config
        self.delegate = delegate
    }
    
    
    func load(adCount:Int){
        state = .loading
        GADRewardedAd.load(withAdUnitID:config.adUnitId,
                               request: request,completionHandler: {[weak self] (ad, error) in
            guard let self = self else{return}
            
            guard let ad = ad else {
                self.handlerError(error:error)
                return
            }
            
            self.fulfill(ad: ad)
        })
    }
    
    func handlerError(error:Error?){
        print("Rewarded Ad failed to load with error: \(String(describing: error?.localizedDescription))")
        self.state = .waiting
        self.delegate?.adLoader(didFinishLoad: self, withError: error)
    }
    
    func fulfill(ad: GADRewardedAd){
        
        let ad = RewardedAdWrapper(ad: ad, config: config)
        delegate?.adLoader(self, didRecive: ad)
        delegate?.adLoader(didFinishLoad: self, withError: nil)
        state = .waiting
    }

}
