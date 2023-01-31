//
//  ErrorHandlerProtocol.swift
//  AdsRepo
//
//  Created by Ali on 9/15/22.
//

import Foundation

public protocol AdRepositoryErrorHandlerProtocol{
    
    typealias RetryClosure = (_ currentAttempt:Int)->()
    
    var delayBetweenRetyies:Int {get set}
    
    var maxRetryCount:Int{get set}
    
    /// Check if the input error is retryable or not. If it's retryable.
    /// - Parameters:
    ///   - error: An error which received from the repository
    /// - Returns: Return `true` if can method retry otherwise return `false`
    func isRetryAble(error: Error)->Bool
    
    
    ///  Will call `retryClosure` after all developer-specific conditions are provided.
    /// - Parameter retry: call input closure after spacific condtion (ex: after period of time)
    func requestForRetry(onRetry retry:@escaping RetryClosure)
    
    /// Will restart retry count.
    func restart()
    
    /// Will cancel last waiting `retryClosure` DispatchWorkItem
    func cancel()
}
