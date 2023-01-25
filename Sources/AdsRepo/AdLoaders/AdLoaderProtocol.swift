//
//  AdLoaderProtocol.swift
//  AdsRepo
//
//  Created by Ali on 1/20/23.
//

import Foundation
import GoogleMobileAds

public protocol AdLoaderProtocol:NSObject {
    
    associatedtype AdWrapperType = AdWrapperProtocol
    
    var state:AdLoaderState{get}
    var config:AdRepositoryConfig{get}
    
    var notifyRepositoryDidReceiveAd:((_ ad:AdWrapperType)->())? { get set }
    var notifyRepositoryDidFinishLoad:((_ withError:Error?)->())? { get set }
    
    init(config:AdRepositoryConfig)
    
    func load(count:Int)
    
}
