//
//  ErrorHandler.swift
//  AdsRepo
//
//  Created by Ali on 9/5/21.
//

import Foundation
import GoogleMobileAds
class ErrorHandler  {
    typealias RetryClosure = ()->Void

    private let defaultMinRetry = 20
    private var retryCount = 0


    
    //return: can method retry or not (as bool)
    @discardableResult
    func isRetryAble(error: Error?,retryClosure:RetryClosure? = nil)->Bool{
        guard let error = error else{
            print("ErrorHandler","unkonwn error")
            retryCount += 1
            recallMethod(delay: 5, retryClosure: retryClosure)
            return true
        }
        
        guard retryCount<=defaultMinRetry else {return false}
        let errorCode = GADErrorCode(rawValue: (error as NSError).code)
        switch (errorCode) {
        //retrable errors
        case .internalError,.receivedInvalidResponse:
            retryCount += 1
            recallMethod(delay: 10, retryClosure: retryClosure)
            print("ErrorHandler","Internal error, an invalid response was received from the ad server.")
            return true
        case .networkError,.timeout,.serverError,.adAlreadyUsed:
            retryCount += 1
            recallMethod(delay: 5, retryClosure: retryClosure)
            print("ErrorHandler","The ad request was unsuccessful due to network connectivity.")
            return true
        case .noFill,.mediationNoFill:
            retryCount += 1
            recallMethod(delay:10, retryClosure: retryClosure)
            print("ErrorHandler","The ad request was successful, but no ad was returned due to lack of ad inventory.")
            return true
        case .osVersionTooLow,.invalidRequest,.applicationIdentifierMissing:
            print("ErrorHandler","Invalid ad request, possibly an incorrect ad unit ID was given.")
            return false;
        case.mediationDataError,.mediationAdapterError,.mediationInvalidAdSize,.invalidArgument:
            return false
        default:
            break
        }
        print("ErrorHandler","unkonwn error")
        return false
    }

    
    func recallMethod(delay:Int,retryClosure:RetryClosure? = nil){
        print("ErrorHandler","retry count:","\(retryCount)","with delay:",delay)
        guard let retryClosure = retryClosure else {return}
        DispatchQueue.global().asyncAfter(deadline:.now()+DispatchTimeInterval.seconds(delay)){
            retryClosure()
        }
    }
    //call it after restart
    func restart(){
        retryCount = 0
    }
    deinit {
        print("deinit => ErrorHandler")
    }
}
