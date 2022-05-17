//
//  ATTHelper.swift
//  AdsRepo
//
//  Created by Ali on 1/3/22.
//

import Foundation
import AppTrackingTransparency
public class ATTHelper{
    public static var state:ATTrackingManager.AuthorizationStatus{
       return ATTrackingManager.trackingAuthorizationStatus
    }
    public static func request(onComplete:((_ status:ATTrackingManager.AuthorizationStatus)->())? = nil){
        ATTrackingManager.requestTrackingAuthorization {onComplete?($0)}
    }
}
