//
//  RewardedAdLoader.swift
//  AdsRepo
//
//  Created by Ali on 1/20/23.
//

import Foundation
import GoogleMobileAds

public class RewardedAdLoader:AdLoaderProtocol{
    
    public var state: AdLoaderState = .waiting
    public var request:GADRequest = GADRequest()
    public  var config:AdRepositoryConfig
    public  weak var delegate:AdLoaderDelegate?
    
    private var count = 0
    
    required public init(config: AdRepositoryConfig) {
        self.config = config
    }
    
    
    public func load(count:Int){
        state = .loading
        self.count = count
        for _ in 0..<count{
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
    }
    
    private func handlerError(error:Error?){
        print("Rewarded Ad failed to load with error: \(String(describing: error?.localizedDescription))")
        self.state = .waiting
        self.delegate?.adLoader(didFinishLoad: self, withError: error)
    }
    
    private func fulfill(ad: GADRewardedAd){
        
        let ad = RewardedAdWrapper(ad: ad, config: config)
        delegate?.adLoader(self, didReceive: ad)
        count -= 1
        if count == 0 {
            delegate?.adLoader(didFinishLoad: self, withError: nil)
        }
        state = .waiting
    }

}
