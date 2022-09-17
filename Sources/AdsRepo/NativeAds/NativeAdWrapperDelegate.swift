//
//  NativeAdWrapperDelegate.swift
//  AdsRepo
//
//  Created by Ali on 8/29/22.
//

import Foundation

public protocol NativeAdWrapperDelegate:NSObject {
    
    /// Will be called when an ad removed from its own repository
    /// - Parameter ad: The ad which removed form own repository
    func nativeAdWrapper(didRemoveFromRepository ad:NativeAdWrapper)
    
    /// Will be called when the `showCount` variable changes. It's will increase each time return ad with `LoadAd` function inside **NativeAdRepository.swift**.
    /// - Parameter ad: The ad which the `showCount` variable increased
    func nativeAdWrapper(didShowCountChanged ad:NativeAdWrapper)
    
    /// Will be called when NativeAdWrapper's timer finished. See `timer` inside **NativeAdWrapper** for more details
    /// - Parameter ad: The ad which did expire
    func nativeAdWrapper(didExpire ad:NativeAdWrapper)
}
extension NativeAdWrapperDelegate {
    public func nativeAdWrapper(didRemoveFromRepository ad:NativeAdWrapper){}
    public func nativeAdWrapper(didShowCountChanged ad:NativeAdWrapper){}
    public func nativeAdWrapper(didExpire ad:NativeAdWrapper){}
}
