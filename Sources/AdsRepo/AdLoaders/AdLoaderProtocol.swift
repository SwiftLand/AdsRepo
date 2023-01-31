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
    
    /// Return current state of this ad loader
    var state:AdLoaderState{get}
    
    /// Repository configuration. See **AdRepositoryConfig.swift** for more details.
    var config:AdRepositoryConfig{get}
    
    
    /// When this ad loader receives an ad, have to call this method. the default ad repository class will notify the new ads received by setting this closure.
    var notifyRepositoryDidReceiveAd:((_ ad:AdWrapperType)->())? { get set }
    
    /// When this ad loader finished loading the ad, have to call this method. the default ad repository class will notify all loading and process finished by setting this closure.
    var notifyRepositoryDidFinishLoad:((_ withError:Error?)->())? { get set }
    
    init(config:AdRepositoryConfig)
    
    /// The default ad repository class will call this function when need to become filled. See **AdRepository.swift** for more details.
    /// - Parameter count: number of require ads
    func load(count:Int)
    
}
