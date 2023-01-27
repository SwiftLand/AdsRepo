//
//  InterstitialAdWrapper.swift
//  AdRepo
//
//  Created by Ali on 9/3/21.
//

import Foundation
import GoogleMobileAds


public class GADInterstitialAdWrapper:NSObject,AdWrapperProtocol {
   
    public var loadedAd:GADInterstitialAd
    
    public private(set) var uniqueId: String  = UUID().uuidString
    
    /// Repository configuration. See **RepositoryConfig.swift** for more details.
    public private(set) var config:AdRepositoryConfig
    
    /// Show GADInterstitialAd load Date (In milisecond). `nil` if GADInterstitialAd does not load yet
    public private(set) var loadedDate:TimeInterval = Date().timeIntervalSince1970
    
    /// Show how many time this object return as valid ads to user. See **`loadAd`** function in **InterstitialAdRepository.swift** for more details
    public var showCount:Int = 0
    
    init(_ ad:GADInterstitialAd,config:AdRepositoryConfig) {
        self.loadedAd = ad
        self.config = config
    }
    
    deinit {
        print("deinit","Interstitial AdWrapper")
    }
}
