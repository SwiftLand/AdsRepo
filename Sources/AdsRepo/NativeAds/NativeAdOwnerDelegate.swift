//
//  NativeAdOwnerDelegate.swift
//  AdsRepo
//
//  Created by Ali on 9/17/22.
//

import Foundation
/// Protocol to communicate `NativeAdWrapper` with its own repository
internal protocol NativeAdOwnerDelegate:NSObject{
    func adWrapper(didExpire ad: NativeAdWrapper)
}
