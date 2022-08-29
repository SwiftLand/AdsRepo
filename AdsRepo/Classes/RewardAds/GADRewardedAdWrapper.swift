//
//  GADRewardedAdWrapper.swift
//  AdsRepo
//
//  Created by Ali on 8/29/22.
//

import Foundation
import GoogleMobileAds

public class GADRewardedAdWrapper:GADRewardedAd{
  
    internal weak var _fullScreenContentDelegate:GADFullScreenContentDelegate?
    
    public override var fullScreenContentDelegate: GADFullScreenContentDelegate?{
        get { return _fullScreenContentDelegate }
        set{ _fullScreenContentDelegate = newValue }
    }
}
