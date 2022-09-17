//
//  InterstitialAdWrapperDelegate.swift
//  AdsRepo
//
//  Created by Ali on 8/29/22.
//

import Foundation

public protocol InterstitialAdWrapperDelegate:NSObject {
    
    /// Will be called when the ad ready to show
    func interstitialAdWrapper(didReady ad:InterstitialAdWrapper)
    
    /// Will be called when the ad will open full-screen
    func interstitialAdWrapper(willOpen ad:InterstitialAdWrapper)
    
    /// Will be called when the ad record a click
    func interstitialAdWrapper(didRecordClick ad:InterstitialAdWrapper)
    
    /// Will be called when the ad record a impression
    func interstitialAdWrapper(didRecordImpression ad:InterstitialAdWrapper)
    
    /// Will be called when the ad become close
    func interstitialAdWrapper(willClose ad:InterstitialAdWrapper)
    
    /// Will be called when the ad did close
    func interstitialAdWrapper(didClose ad:InterstitialAdWrapper)
    
    /// Will be called when the `showCount` variable changes. It's will increase each time return ad with `presentAd` function inside **InterstitialAdRepository.swift**.
    func interstitialAdWrapper(didShowCountChanged ad:InterstitialAdWrapper)
    
 
    /// Will be called when an ad removed from its own repository
    func interstitialAdWrapper(didRemoveFromRepository ad:InterstitialAdWrapper)
    
    /// Will be called when the ad received an error during load
    func interstitialAdWrapper(onError ad:InterstitialAdWrapper,error:Error?)
    
    ///Will be called when InterstitialAdWrapper's timer finished. See `timer` inside **InterstitialAdWrapper** for more details
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
