//
//  IntesetinalAdLoader.swift
//  AdsRepo
//
//  Created by Ali on 1/20/23.
//

import Foundation
import GoogleMobileAds

public class InterstitialAdLoader:NSObject,AdLoaderProtocol{

    public typealias AdWrapperType = GADInterstitialAdWrapper
    public private(set) var state: AdLoaderState = .waiting
    public var request:GADRequest = GADRequest()
    public var config:AdRepositoryConfig
    
    public var notifyRepositoryDidReceiveAd: ((AdWrapperType) -> ())?
    public var notifyRepositoryDidFinishLoad: ((Error?) -> ())?
    
    private var count = 0
    internal var Loader = GADInterstitialAd.self
    
    required public init(config: AdRepositoryConfig) {
        self.config = config
    }
    
    
    public func load(count:Int){
        guard state == .waiting else {return}
        state = .loading
        self.count = count
        for _ in 0..<count{
            Loader.load(withAdUnitID:config.adUnitId,
                        request: request,completionHandler: {[weak self] (ad, error) in
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
    
    private func fulfill(ad: GADInterstitialAd){
        notifyRepositoryDidReceiveAd?(GADInterstitialAdWrapper(ad, config: config))
        notifyFinishLoadIfNeed()
    }
}
