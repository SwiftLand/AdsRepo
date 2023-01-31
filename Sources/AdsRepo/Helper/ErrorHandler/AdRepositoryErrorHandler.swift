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
    
    private let TAG = "\(AdRepositoryErrorHandler.self)"
    @Atomic public var delayBetweenRetyies:Int = 5
    @Atomic public var maxRetryCount:Int = 10
    
    internal var currentRetryCount = 0
    internal var lastWorkItem:DispatchWorkItem?  = nil
    
    
    /// Check if the input error is retryable or not. If it's retryable.
    /// - Parameters:
    ///   - error: An error which received from the repository
    /// - Returns: Return `true` if can method retry otherwise return `false`
    func isRetryAble(error: Error) -> Bool {
        
        guard currentRetryCount < maxRetryCount else {return false}
        
        let errorCode = GADErrorCode(rawValue: (error as NSError).code)
        switch (errorCode) {
            //retrable errors
        case .internalError,.receivedInvalidResponse:
            print(TAG,"Internal error, an invalid response was received from the ad server.")
            return true
        case .networkError,.timeout,.serverError,.adAlreadyUsed:
            print(TAG,"The ad request was unsuccessful due to network connectivity.")
            return true
        case .noFill,.mediationNoFill:
            print(TAG,"The ad request was successful, but no ad was returned due to lack of ad inventory.")
            return true
        case .osVersionTooLow,.invalidRequest,.applicationIdentifierMissing:
            print(TAG,"Invalid ad request, possibly an incorrect ad unit ID was given.")
            return false;
        case.mediationDataError,.mediationAdapterError,.mediationInvalidAdSize,.invalidArgument:
            print(TAG,"Invalid ad request, possibly an incorrect ad mediation setting.")
            return false
        default:
            break
        }
        print(TAG,"unkonwn error")
        return false
    }
    
    /// Will call `retryClosure` after specific delay based on `delayBetweenRetyies` value
    /// - Parameter retry: call input closure after dealy
    func requestForRetry(onRetry retry:@escaping RetryClosure){
        currentRetryCount += 1
        recallMethod(onRetry:retry)
    }
    
    private func recallMethod(onRetry retry:@escaping RetryClosure){
        
        print(TAG,"retry count:","\(currentRetryCount)","with delay:",delayBetweenRetyies)
        
        lastWorkItem = DispatchWorkItem{[weak self] in
            guard let self = self else {return}
            retry(self.currentRetryCount)
        }
        
        let delay = DispatchTimeInterval.seconds(delayBetweenRetyies)
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
