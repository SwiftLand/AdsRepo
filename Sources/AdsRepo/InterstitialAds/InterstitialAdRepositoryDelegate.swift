//
//  InterstitialAdRepositoryDelegate.swift
//  AdsRepo
//
//  Created by Ali on 8/29/22.
//

import Foundation
public protocol InterstitialAdRepositoryDelegate:NSObject {
    func interstitialAdRepository(didReceive repo:InterstitialAdRepository)
    func interstitialAdRepository(didFinishLoading repo:InterstitialAdRepository,error:Error?)
}

extension InterstitialAdRepositoryDelegate {
    public func interstitialAdRepository(didReceive repo:InterstitialAdRepository){}
    public func interstitialAdRepository(didFinishLoading repo:InterstitialAdRepository,error:Error?){}
}
