//
//  Helper.swift
//  AdsRepo
//
//  Created by Ali on 7/22/22.
//

import Foundation
import GoogleMobileAds

public func setTestDevices(deviceIds:[String]){
    GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = deviceIds
}
