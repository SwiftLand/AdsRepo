//
//  AdState.swift
//  AdsRepo
//
//  Created by Ali on 8/29/22.
//

import Foundation

/// Ad state that used for interstitial Ads and rewarded ads
public enum AdState:Int{
    case waiting = 0
    case loading = 1
    case loaded = 2
    case error = 3
}
