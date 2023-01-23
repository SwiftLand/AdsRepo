//
//  RewardAdWrapper.swift
//  AdRepo
//
//  Created by Ali on 9/2/21.
//

import Foundation
import GoogleMobileAds
import UIKit

public class RewardedAdWrapper:NSObject,AdWrapperProtocol{
    
    public var loadedAd:GADRewardedAd
    
    public private(set) var id: String  = UUID().uuidString
    
    /// Repository configuration. See **RepositoryConfig.swift** for more details.
    public private(set) var config:AdRepositoryConfig
    
    /// Show GADInterstitialAd load Date (In milisecond). `nil` if GADInterstitialAd does not load yet
    public private(set) var loadedDate:TimeInterval = Date().timeIntervalSince1970
    
    /// Show how many time this object return as valid ads to user. See **`loadAd`** function in **InterstitialAdRepository.swift** for more details
    public var showCount:Int = 0
    
    /// return `true` if the reward is successfully Received otherwise return `false`
    public private(set) var isRewardReceived:Bool = false
    
    
    init(ad:GADRewardedAd,config:AdRepositoryConfig) {
        
        self.loadedAd = ad
        self.config = config
        super.init()
    }
    
    deinit {
        print("deinit","Interstitial AdWrapper")
    }
}
