//
//  ErrorHandlerConfig.swift
//  AdsRepo
//
//  Created by Ali on 9/15/22.
//

import Foundation
public struct ErrorHandlerConfig{
    public static let defaultDelayBetweenRetyies:Int = 5
    public static let defaultMaxRetryCount:Int = 20
    
    
    /// Delay between each retries (base on seconds)
    public var delayBetweenRetries = ErrorHandlerConfig.defaultDelayBetweenRetyies
    
    /// The maximum number to retry  before fail
    public var maxRetryCount = ErrorHandlerConfig.defaultMaxRetryCount
}
