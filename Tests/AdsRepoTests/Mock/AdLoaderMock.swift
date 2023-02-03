//
//  AdLoaderMock.swift
//  AdsRepo-Unit-Tests
//
//  Created by Ali on 2/3/23.
//


import Foundation
@testable import AdsRepo



class AdLoaderMock:NSObject,AdLoaderProtocol{

    typealias AdWrapperType = AdWrapperMock
    
    var state: AdLoaderState = .waiting
    var config:AdRepositoryConfig
   
    
    var notifyRepositoryDidReceiveAd: ((AdWrapperType) -> ())?
    var notifyRepositoryDidFinishLoad: ((Error?) -> ())?

    
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
            let adWrapper = AdWrapperMock(loadedAd:  AdMock(), config: config)
            loadedAds.append(adWrapper)
            notifyRepositoryDidReceiveAd?(adWrapper)
        }
        
        state = .waiting
        notifyRepositoryDidFinishLoad?(nil)
    }
}
