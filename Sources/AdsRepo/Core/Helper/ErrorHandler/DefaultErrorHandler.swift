//
//  ErrorHandler.swift
//  AdsRepo
//
//  Created by Ali on 9/5/21.
//

import Foundation

/// `ErrorHandler` will handle all types of repository errors. it is configurable to retry at a specific time before the return fails to its own repository.
open class DefaultErrorHandler:NSObject,AdRepositoryErrorHandlerProtocol  {
    
    public var delayBetweenRetyies:Int = 5
    public var maxRetryCount:Int = 10

    internal var currentRetryCount = 0
    internal var lastWorkItem:DispatchWorkItem?  = nil
    
    
    /// Check if the input error is retryable or not. If it's retryable.
    /// - Parameters:
    ///   - error: An error which received from the repository
    /// - Returns: Return `true` if can method retry otherwise return `false`
    open func isRetryAble(error: Error) -> Bool {
        
        guard currentRetryCount < maxRetryCount else {return false}
        return true
    }
    
    /// Will call `retryClosure` after specific delay based on `delayBetweenRetyies` value
    /// - Parameter retry: call input closure after dealy
    open func requestForRetry(onRetry retry:@escaping RetryClosure){
        currentRetryCount += 1
        recallMethod(onRetry:retry)
    }
    
    private func recallMethod(onRetry retry:@escaping RetryClosure){
        
        print("\(DefaultErrorHandler.self)","retry count:","\(currentRetryCount)","with delay:",delayBetweenRetyies)
        
        lastWorkItem = DispatchWorkItem{[weak self] in
            guard let self = self else {return}
            retry(self.currentRetryCount)
        }
        
        let delay = DispatchTimeInterval.seconds(delayBetweenRetyies)
        DispatchQueue.main.asyncAfter(deadline: .now()+delay, execute: lastWorkItem!)
    }
    
    ///Will restart retry count
    open func restart(){
        currentRetryCount = 0
    }
    
    ///Will cancel last waiting `retryClosure` DispatchWorkItem
    open func cancel(){
        lastWorkItem?.cancel()
        lastWorkItem = nil
    }
}
