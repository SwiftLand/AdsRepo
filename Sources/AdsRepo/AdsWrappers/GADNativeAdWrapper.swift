//
//  NativeAdWrapper.swift
//  AdRepo
//
//  Created by Ali on 9/2/21.
//

import Foundation
import GoogleMobileAds

public class GADNativeAdWrapper:NSObject,AdWrapperProtocol{

    /// Repository configuration. See **RepositoryConfig.swift** for more details.
    public private(set) var config:AdRepositoryConfig
    
    public private(set) var uniqueId: String  = UUID().uuidString
    
    public private(set) var loadedAd: GADNativeAd
    /// Show GADNativeAd load Date (In milisecond)
    public private(set) var loadedDate:TimeInterval = Date().timeIntervalSince1970
    
    /// Show how many time this object return as valid ads to user. See **`loadAd`** function in **NativeAdRepository.swift** for more details
    public var showCount:Int = 0
    
    
    init(loadedAd: GADNativeAd,config:AdRepositoryConfig){
        
        self.config = config
        self.loadedAd = loadedAd
    }
    
    deinit {
        print("deinit","Native Ad")
    }
}
