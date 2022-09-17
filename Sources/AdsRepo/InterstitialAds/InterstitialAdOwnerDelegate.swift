//
//  InterstitialAdOwnerDelegate.swift
//  AdsRepo
//
//  Created by Ali on 8/29/22.
//

import Foundation

/// Protocol to communicate `InterstitialAdWrapper` with its own repository
internal protocol InterstitialAdOwnerDelegate:NSObject{
    func adWrapper(didReady ad:InterstitialAdWrapper)
    func adWrapper(didClose ad:InterstitialAdWrapper)
    func adWrapper(onError ad:InterstitialAdWrapper, error: Error?)
    func adWrapper(didExpire ad: InterstitialAdWrapper)
}
