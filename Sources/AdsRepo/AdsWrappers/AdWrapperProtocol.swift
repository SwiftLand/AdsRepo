//
//  AdWrapperProtocol.swift
//  AdsRepo
//
//  Created by Ali on 9/23/22.
//

import Foundation
import GoogleMobileAds


public protocol AdWrapperProtocol:NSObject,Hashable{
    
    associatedtype AdType:NSObject
    /// Repository configuration. See **RepositoryConfig.swift** for more details.
    var config:RepositoryConfig{get}
   
    var id:String{get}
    
    /// GADNativeAd object that loaded successfully with adLoader inside `owner` Repository object
    var loadedAd:AdType{get}
    
    /// Show GADNativeAd load Date (In milisecond)
    var loadedDate:TimeInterval{get}
    
    /// Show how many time this object return as valid ads to user. See **`loadAd`** function in **NativeAdRepository.swift** for more details
    var showCount:Int{get}
    
    func increaseShowCount()
}
