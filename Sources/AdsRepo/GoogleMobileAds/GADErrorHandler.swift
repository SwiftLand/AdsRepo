//
//  ErrorHandlerExtender.swift
//  AdsRepo
//
//  Created by Ali on 2/3/23.
//

import Foundation
import GoogleMobileAds

#if SWIFT_PACKAGE
import AdsRepo
#endif


class GADErrorHandler: DefaultErrorHandler {
    
    override func isRetryAble(error: Error) -> Bool {
        guard (error as NSError).domain == GADErrorDomain else {
            return true
        }
        return isGADRetryAble(error: error)
    }
    
    func isGADRetryAble(error: Error) -> Bool {

        let errorCode = GADErrorCode(rawValue: (error as NSError).code)
        switch (errorCode) {
        case .internalError,.receivedInvalidResponse:
            print("GoogleMobileAds","Internal error, an invalid response was received from the ad server.")
            return true
        case .networkError,.timeout,.serverError,.adAlreadyUsed:
            print("GoogleMobileAds","The ad request was unsuccessful due to network connectivity.")
            return true
        case .noFill,.mediationNoFill:
            print("GoogleMobileAds","The ad request was successful, but no ad was returned due to lack of ad inventory.")
            return true
        case .osVersionTooLow,.invalidRequest,.applicationIdentifierMissing:
            print("GoogleMobileAds","Invalid ad request, possibly an incorrect ad unit ID was given.")
            return false;
        case.mediationDataError,.mediationAdapterError,.mediationInvalidAdSize,.invalidArgument:
            print("GoogleMobileAds","Invalid ad request, possibly an incorrect ad mediation setting.")
            return false
        default:
            break
        }
        print("GoogleMobileAds","unkonwn error")
        return false
        
    }
}
