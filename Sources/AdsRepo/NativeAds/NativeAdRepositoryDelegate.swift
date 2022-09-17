//
//  NativeAdWrapperDelegate.swift
//  AdsRepo
//
//  Created by Ali on 8/29/22.
//

import Foundation

public protocol NativeAdRepositoryDelegate:NSObject{
    
    ///Will call after each ad receives
    /// - Parameter repo: current native Ad repository
    func nativeAdRepository(didReceive repo:NativeAdRepository)
    

    ///Will call after repository fill or can't handle error any more.
    /// - Parameters:
    ///   - repo: Current native Ad repository
    ///   - error: Final error after retries base on error handler object. see **ErrorHandler.swift** for more details
    func nativeAdRepository(didFinishLoading repo:NativeAdRepository,error:Error?)
}
extension NativeAdRepositoryDelegate{
    public func nativeAdRepository(didReceive repo:NativeAdRepository){}
    public func nativeAdRepository(didFinishLoading repo:NativeAdRepository,error:Error?){}
}
