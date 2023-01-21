//
//  ErrorHandlerProtocol.swift
//  AdsRepo
//
//  Created by Ali on 9/15/22.
//

import Foundation

protocol ErrorHandlerProtocol{
    
    /// Keep all configuration and policy that how retries after each fail.
    var config:ErrorHandlerConfig{get}
    var delegate:ErrorHandlerDelegate?{get set}
    /// Check if the input error is retryable or not. If it's retryable, will call `retryClosure` after all conditions (which are declared in the `ErrorHandler Config` variable) are provided.
    /// - Parameters:
    ///   - error: An error which received from the repository
    /// - Returns: Return `true` if can method retry otherwise return `false`
    func isRetryAble(error: Error?)->Bool
    
    /// Will restart retry count.
    func restart()
    
    /// Will cancel last waiting `retryClosure` DispatchWorkItem
    func cancel()
}
