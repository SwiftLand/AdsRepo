//
//  NativeAdWrapperDelegate.swift
//  AdsRepo
//
//  Created by Ali on 8/29/22.
//

import Foundation

public protocol NativeAdRepositoryDelegate:NSObject{
    func nativeAdRepository(didReceive repo:NativeAdRepository)
    func nativeAdRepository(didFinishLoading repo:NativeAdRepository,error:Error?)
}
extension NativeAdRepositoryDelegate{
    public func nativeAdRepository(didReceive repo:NativeAdRepository){}
    public func nativeAdRepository(didFinishLoading repo:NativeAdRepository,error:Error?){}
}
