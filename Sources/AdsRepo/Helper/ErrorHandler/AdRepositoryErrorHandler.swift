//
//  ErrorHandler.swift
//  AdsRepo
//
//  Created by Ali on 9/5/21.
//

import Foundation
import GoogleMobileAds

/// `ErrorHandler` will handle all types of repository errors. it is configurable to retry at a specific time before the return fails to its own repository.
class AdRepositoryErrorHandler:AdRepositoryErrorHandlerProtocol  {
    
    
    public static let delayBetweenRetyies:Int = 5
    public static let maxRetryCount:Int = 20
    
    internal var currentRetryCount = 0
    internal var lastWorkItem:DispatchWorkItem?  = nil
    
    
    /// check if the input error is retryable or not. If it's retryable, will call `retryClosure` after all conditions (which are declared in the `ErrorHandler Config` variable) are provided.
    /// - Parameters:
    ///   - error: An error which received from the repository
    ///   - retryClosure: Will execute  after all condition (which are declared in the `ErrorHandlerConfig` variable) provided
    /// - Returns: Return `true` if can method retry otherwise return `false`
   
    func isRetryAble(error: Error) -> Bool {
        
        guard currentRetryCount < AdRepositoryErrorHandler.maxRetryCount else {return false}
        
        let errorCode = GADErrorCode(rawValue: (error as NSError).code)
        switch (errorCode) {
            //retrable errors
        case .internalError,.receivedInvalidResponse:
            print("ErrorHandler","Internal error, an invalid response was received from the ad server.")
            return true
        case .networkError,.timeout,.serverError,.adAlreadyUsed:
            print("ErrorHandler","The ad request was unsuccessful due to network connectivity.")
            return true
        case .noFill,.mediationNoFill:
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
    
    func requestForRetry(onRetry retry:@escaping RetryClosure){
        currentRetryCount += 1
        recallMethod(onRetry:retry)
    }
    
    private func recallMethod(onRetry retry:@escaping RetryClosure){
        
        print("ErrorHandler","retry count:","\(currentRetryCount)","with delay:",AdRepositoryErrorHandler.delayBetweenRetyies)
        
        
        lastWorkItem = DispatchWorkItem{[weak self] in
            guard let self = self else {return}
            retry(self.currentRetryCount)
        }
        
        let delay = DispatchTimeInterval.seconds(AdRepositoryErrorHandler.delayBetweenRetyies)
        DispatchQueue.main.asyncAfter(deadline: .now()+delay, execute: lastWorkItem!)
    }
    
    ///Will restart retry count
    func restart(){
        currentRetryCount = 0
    }
    
    ///Will cancel last waiting `retryClosure` DispatchWorkItem
    func cancel(){
        lastWorkItem?.cancel()
        lastWorkItem = nil
    }
    
    deinit {
        print("deinit => ErrorHandler")
    }
}
