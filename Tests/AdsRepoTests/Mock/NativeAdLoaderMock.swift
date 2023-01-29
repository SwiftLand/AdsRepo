//
//  MockNativeAdLoader.swift
//  AdsRepo-Unit-Tests
//
//  Created by Ali on 1/27/23.
//

import Foundation
import GoogleMobileAds
@testable import AdsRepo

public class NativeAdLoaderMock:NSObject,AdLoaderProtocol{

    public typealias AdWrapperType = GADNativeAdWrapper
    
    public var state: AdLoaderState = .waiting
    public var config:AdRepositoryConfig
   
    
    public var notifyRepositoryDidReceiveAd: ((AdWrapperType) -> ())?
    public var notifyRepositoryDidFinishLoad: ((Error?) -> ())?

    
    //for tests
    var loadedAds:[AdWrapperType] = []
    var responseError:Error? = nil
    var canLoad = true
    
    required public init(config: AdRepositoryConfig) {
        self.config = config
    }
    
    public func load(count:Int){
        guard canLoad else { return}
        state = .loading
        loadMock(count: count)
    }
    
    private func loadMock(count:Int){
        if let error = responseError  {
            state = .waiting
            notifyRepositoryDidFinishLoad?(error)
            return
        }
        
        for _ in 0..<count{
            let adWrapper = GADNativeAdWrapper(loadedAd:  GADNativeAdMock(), config: config)
            loadedAds.append(adWrapper)
            notifyRepositoryDidReceiveAd?(adWrapper)
        }
        
        state = .waiting
        notifyRepositoryDidFinishLoad?(nil)
    }
}

