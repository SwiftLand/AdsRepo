//
//  RewardAdWrapper.swift
//  AdRepo
//
//  Created by Ali on 9/2/21.
//

import Foundation
import GoogleMobileAds

public class GADRewardedAdWrapper:NSObject,AdWrapperProtocol{
    
    /// Repository configuration. See **AdRepositoryConfig.swift** for more details.
    public private(set) var config:AdRepositoryConfig
    
    /// Unique id for the ad wrapper that used for some process in the ad's own repository
    public private(set) var uniqueId: String  = UUID().uuidString
    
    /// Loaded GADRewardedAd  object
    public var loadedAd:GADRewardedAd
    
    /// GADRewardedAd's  loaded Date
    public private(set) var loadedDate:Date = Date()
    
    /// Show how many time this GADRewardedAdWrapper return as valid ads to user. See **loadAd** function in **AdRepository.swift** for more details
    /// - NOTE: This value typically changes by the ad's own repository but you can also change it if failed to show/present returned ad.
    /// - Important: This property is thread-safe
    @Atomic public var showCount:Int = 0
    
    init(ad:GADRewardedAd,config:AdRepositoryConfig) {
        self.loadedAd = ad
        self.config = config
    }
}
