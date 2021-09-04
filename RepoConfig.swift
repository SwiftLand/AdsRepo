//
//  RepoConfig.swift
//  AdsRepo
//
//  Created by Ali on 9/4/21.
//

import Foundation
public struct RepoConfig{
     let AdUnitId:String
     let totalSize:Int
     let expireIntervalTime:TimeInterval
     let isTaggedForChildDirectedTreatment: Bool?// COPPA
     let isTaggedForUnderAgeOfConsent: Bool // GDPR
     let isUMPDisabled: Bool?// Disables User Messaging Platform (UMP) SDK
    
   public init(
        AdUnitId:String,
        totalSize:Int,
        expireIntervalTime:TimeInterval = 360000,
        isTaggedForChildDirectedTreatment: Bool?  = nil ,
        isTaggedForUnderAgeOfConsent: Bool = false,
        isUMPDisabled: Bool? = nil ) {
        
        self.AdUnitId = AdUnitId
        self.totalSize = totalSize
        self.expireIntervalTime = expireIntervalTime
        self.isTaggedForChildDirectedTreatment = isTaggedForChildDirectedTreatment
        self.isTaggedForUnderAgeOfConsent = isTaggedForUnderAgeOfConsent
        self.isUMPDisabled = isUMPDisabled
    }
}
