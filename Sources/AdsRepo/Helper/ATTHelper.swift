//
//  ATTHelper.swift
//  AdsRepo
//
//  Created by Ali on 1/3/22.
//

import Foundation
import AppTrackingTransparency

/// Helper for use AppTrackingTransparency
public class ATTHelper{
    @available(iOS 14, *)
    public static var state:ATTrackingManager.AuthorizationStatus{
       return ATTrackingManager.trackingAuthorizationStatus
    }
    @available(iOS 14, *)
    public static func request(onComplete:((_ status:ATTrackingManager.AuthorizationStatus)->())? = nil){
        ATTrackingManager.requestTrackingAuthorization {onComplete?($0)}
    }
}
