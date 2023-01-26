//
//  ErrorHandlerProtocol.swift
//  AdsRepo
//
//  Created by Ali on 9/15/22.
//

import Foundation

public protocol AdRepositoryErrorHandlerProtocol{
    
    typealias RetryClosure = (_ currentAttempt:Int)->()
    
    /// Check if the input error is retryable or not. If it's retryable, will call `retryClosure` after all conditions (which are declared in the `ErrorHandler Config` variable) are provided.
    /// - Parameters:
    ///   - error: An error which received from the repository
    /// - Returns: Return `true` if can method retry otherwise return `false`
    func isRetryAble(error: Error)->Bool
    
    func requestForRetry(onRetry retry:@escaping RetryClosure)
    
    /// Will restart retry count.
    func restart()
    
    /// Will cancel last waiting `retryClosure` DispatchWorkItem
    func cancel()
}
