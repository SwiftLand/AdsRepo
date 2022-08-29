//
//  NativeAdWrapperDelegate.swift
//  AdsRepo
//
//  Created by Ali on 8/29/22.
//

import Foundation

public protocol NativeAdWrapperDelegate:NSObject {
    func nativeAdWrapper(didRemoveFromRepository ad:NativeAdWrapper)
    func nativeAdWrapper(didShowCountChanged ad:NativeAdWrapper)
    func nativeAdWrapper(didExpire ad:NativeAdWrapper)
}
extension NativeAdWrapperDelegate {
    public func nativeAdWrapper(didRemoveFromRepository ad:NativeAdWrapper){}
    public func nativeAdWrapper(didShowCountChanged ad:NativeAdWrapper){}
    public func nativeAdWrapper(didExpire ad:NativeAdWrapper){}
}
