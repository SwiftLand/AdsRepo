//
//  ErrorHandler.swift
//  AdsRepo
//
//  Created by Ali on 9/5/21.
//

import Foundation
import GoogleMobileAds

/// `ErrorHandler` will handle all types of repository errors. it is configurable to retry at a specific time before the return fails to its own repository.
class ErrorHandler:ErrorHandlerProtocol  {
    
    /// Keep all configuration and policy that how retries after each fail
    let config:ErrorHandlerConfig
    
    weak var delegate:ErrorHandlerDelegate?
    
    private(set) var currentRetryCount = 0
    private var lastWorkItem:DispatchWorkItem?  = nil
    
    
    init(config:ErrorHandlerConfig? = nil) {
        self.config = config ?? ErrorHandlerConfig()
    }



    /// check if the input error is retryable or not. If it's retryable, will call `retryClosure` after all conditions (which are declared in the `ErrorHandler Config` variable) are provided.
    /// - Parameters:
    ///   - error: An error which received from the repository
    ///   - retryClosure: Will execute  after all condition (which are declared in the `ErrorHandlerConfig` variable) provided
    /// - Returns: Return `true` if can method retry otherwise return `false`
    @discardableResult
    func isRetryAble(error: Error?)->Bool{
        guard let error = error else{
            print("ErrorHandler","unkonwn error")
            currentRetryCount += 1
            recallMethod(error)
            return true
        }
        
        guard currentRetryCount<=config.maxRetryCount else {return false}
        let errorCode = GADErrorCode(rawValue: (error as NSError).code)
        switch (errorCode) {
        //retrable errors
        case .internalError,.receivedInvalidResponse:
            currentRetryCount += 1
            recallMethod(error)
            print("ErrorHandler","Internal error, an invalid response was received from the ad server.")
            return true
        case .networkError,.timeout,.serverError,.adAlreadyUsed:
            currentRetryCount += 1
            recallMethod(error)
            print("ErrorHandler","The ad request was unsuccessful due to network connectivity.")
            return true
        case .noFill,.mediationNoFill:
            currentRetryCount += 1
            recallMethod(error)
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

    
   private func recallMethod(_ error:Error?){
        print("ErrorHandler","retry count:","\(currentRetryCount)","with delay:",config.delayBetweenRetries)
    
        lastWorkItem = DispatchWorkItem{[weak self] in
            guard let self = self else {return}
            self.delegate?.errorHandler(onRetry: self.currentRetryCount, for: error)
        }
        DispatchQueue.global().asyncAfter(deadline: .now()+DispatchTimeInterval.seconds(config.delayBetweenRetries)
                                          , execute: lastWorkItem!)
    }
    
    ///Will restart retry count
    func restart(){
        currentRetryCount = 0
    }
    
    ///Will cancel last waiting `retryClosure` DispatchWorkItem
    func cancel(){
        lastWorkItem?.cancel()
    }
    deinit {
        print("deinit => ErrorHandler")
    }
}
