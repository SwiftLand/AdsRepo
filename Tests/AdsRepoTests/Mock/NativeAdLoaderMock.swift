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
    //for tests
//    static let RESPONSE_DELAY:Int = 1 // in seacond
    
    
    public typealias AdWrapperType = GADNativeAdWrapper
    
    public var state: AdLoaderState = .waiting
    public var config:AdRepositoryConfig
   
    
    public var notifyRepositoryDidReceiveAd: ((AdWrapperType) -> ())?
    public var notifyRepositoryDidFinishLoad: ((Error?) -> ())?

    
  
    var loadedAds:[AdWrapperType] = []
    var responseError:Error? = nil
    
    required public init(config: AdRepositoryConfig) {
        self.config = config
    }
    
    public func load(count:Int){
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

