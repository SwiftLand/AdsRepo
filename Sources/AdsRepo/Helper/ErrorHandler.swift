//
//  ErrorHandler.swift
//  AdsRepo
//
//  Created by Ali on 9/5/21.
//

import Foundation
import GoogleMobileAds

public struct ErrorHandlerConfig{
    public static let defaultDelayBetweenRetyies:Int = 5
    public static let defaultMaxRetryCount:Int = 20
    
    public var delayBetweenRetries = ErrorHandlerConfig.defaultDelayBetweenRetyies// second
    public var maxRetryCount = ErrorHandlerConfig.defaultMaxRetryCount
}

protocol ErrorHandlerProtocol{
    typealias RetryClosure = ()->Void
    var config:ErrorHandlerConfig{get}
    func isRetryAble(error: Error?,retryClosure:RetryClosure?)->Bool
    func restart()
    func cancel()
}

class ErrorHandler:ErrorHandlerProtocol  {
    let config:ErrorHandlerConfig
    private(set) var currentRetryCount = 0
    private var lastWorkItem:DispatchWorkItem?  = nil
    init(config:ErrorHandlerConfig? = nil) {
        self.config = config ?? ErrorHandlerConfig()
    }

    //return: can method retry or not (as bool)
    @discardableResult
    func isRetryAble(error: Error?,retryClosure:RetryClosure? = nil)->Bool{
        guard let error = error else{
            print("ErrorHandler","unkonwn error")
            currentRetryCount += 1
            recallMethod(retryClosure: retryClosure)
            return true
        }
        
        guard currentRetryCount<=config.maxRetryCount else {return false}
        let errorCode = GADErrorCode(rawValue: (error as NSError).code)
        switch (errorCode) {
        //retrable errors
        case .internalError,.receivedInvalidResponse:
            currentRetryCount += 1
            recallMethod(retryClosure: retryClosure)
            print("ErrorHandler","Internal error, an invalid response was received from the ad server.")
            return true
        case .networkError,.timeout,.serverError,.adAlreadyUsed:
            currentRetryCount += 1
            recallMethod(retryClosure: retryClosure)
            print("ErrorHandler","The ad request was unsuccessful due to network connectivity.")
            return true
        case .noFill,.mediationNoFill:
            currentRetryCount += 1
            recallMethod(retryClosure: retryClosure)
            print("ErrorHandler","The ad request was successful, but no ad was returned due to lack of ad inventory.")
            return true
        case .osVersionTooLow,.invalidRequest,.applicationIdentifierMissing:
            print("ErrorHandler","Invalid ad request, possibly an incorrect ad unit ID was given.")
            return false;
        case.mediationDataError,.mediationAdapterError,.mediationInvalidAdSize,.invalidArgument:
            print("ErrorHandler","Invalid ad request, possibly an incorrect ad mediation setting.")
            return false
        default:
            break
        }
        print("ErrorHandler","unkonwn error")
        return false
    }

    
    func recallMethod(retryClosure:RetryClosure? = nil){
        print("ErrorHandler","retry count:","\(currentRetryCount)","with delay:",config.delayBetweenRetries)
        guard let retryClosure = retryClosure else {return}
        lastWorkItem = DispatchWorkItem{retryClosure()}
        DispatchQueue.global().asyncAfter(deadline: .now()+DispatchTimeInterval.seconds(config.delayBetweenRetries)
                                          , execute: lastWorkItem!)
    }
    //call it after restart
    func restart(){
        currentRetryCount = 0
    }
    func cancel(){
        lastWorkItem?.cancel()
    }
    deinit {
        print("deinit => ErrorHandler")
    }
}
