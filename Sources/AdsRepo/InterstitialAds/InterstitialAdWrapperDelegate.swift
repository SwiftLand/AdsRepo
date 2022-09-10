//
//  InterstitialAdWrapperDelegate.swift
//  AdsRepo
//
//  Created by Ali on 8/29/22.
//

import Foundation
public protocol InterstitialAdWrapperDelegate:NSObject {
    func interstitialAdWrapper(didReady ad:InterstitialAdWrapper)
    func interstitialAdWrapper(willOpen ad:InterstitialAdWrapper)
    func interstitialAdWrapper(didRecordClick ad:InterstitialAdWrapper)
    func interstitialAdWrapper(didRecordImpression ad:InterstitialAdWrapper)
    func interstitialAdWrapper(willClose ad:InterstitialAdWrapper)
    func interstitialAdWrapper(didClose ad:InterstitialAdWrapper)
    func interstitialAdWrapper(didShowCountChanged ad:InterstitialAdWrapper)
    func interstitialAdWrapper(didRemoveFromRepository ad:InterstitialAdWrapper)
    func interstitialAdWrapper(onError ad:InterstitialAdWrapper,error:Error?)
    func interstitialAdWrapper(didExpire ad:InterstitialAdWrapper)
}
extension InterstitialAdWrapperDelegate {
    public func interstitialAdWrapper(didReady ad:InterstitialAdWrapper){}
    public func interstitialAdWrapper(willOpen ad:InterstitialAdWrapper){}
    public func interstitialAdWrapper(didRecordClick ad:InterstitialAdWrapper){}
    public func interstitialAdWrapper(didRecordImpression ad:InterstitialAdWrapper){}
    public func interstitialAdWrapper(willClose ad:InterstitialAdWrapper){}
    public func interstitialAdWrapper(didClose ad:InterstitialAdWrapper){}
    public func interstitialAdWrapper(didShowCountChanged ad:InterstitialAdWrapper){}
    public func interstitialAdWrapper(didRemoveFromRepository ad:InterstitialAdWrapper){}
    public func interstitialAdWrapper(onError ad:InterstitialAdWrapper,error:Error?){}
    public func interstitialAdWrapper(didExpire ad:InterstitialAdWrapper){}
}
