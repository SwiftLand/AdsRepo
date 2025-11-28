//
//  RewardedAdLoader.swift
//  AdsRepo
//
//  Created by Ali on 1/20/23.
//

import Foundation
import GoogleMobileAds

#if SWIFT_PACKAGE
import AdsRepo
#endif

public class RewardedAdLoader:NSObject,AdLoaderProtocol{
    
    public typealias AdWrapperType = GADRewardedAdWrapper
    
    public private(set) var state: AdLoaderState = .waiting
    public var request:Request = Request()
    public var config:AdRepositoryConfig
    
    public var notifyRepositoryDidReceiveAd: ((AdWrapperType) -> ())?
    public var notifyRepositoryDidFinishLoad: ((Error?) -> ())?
    
    private var count = 0
    internal var Loader = RewardedAd.self
    
    required public init(config: AdRepositoryConfig) {
        self.config = config
    }
    
    
    public func load(count:Int){
        state = .loading
        self.count = count
        for _ in 0..<count{
            Loader.load(with:config.adUnitId,
                        request: request,
                        completionHandler: {[weak self] (ad, error) in
                guard let self = self else{return}
                
                guard let ad = ad else {
                    self.notifyFinishLoadIfNeed(error:error)
                    return
                }
                
                self.fulfill(ad: ad)
            })
        }
    }
    
    private func notifyFinishLoadIfNeed(error:Error? = nil){
        count -= 1
        if count == 0 {
            state = .waiting
            notifyRepositoryDidFinishLoad?(error)
        }
    }
    
    private func fulfill(ad: RewardedAd){
        notifyRepositoryDidReceiveAd?(GADRewardedAdWrapper(loadedAd: ad, config: config))
        notifyFinishLoadIfNeed()
    }
}
