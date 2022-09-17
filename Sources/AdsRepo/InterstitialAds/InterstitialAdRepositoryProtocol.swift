//
//  InterstitialAdRepositoryProtocol.swift
//  AdsRepo
//
//  Created by Ali on 9/17/22.
//

import Foundation

public protocol InterstitialAdRepositoryProtocol:AdsRepoProtocol{

    ///  Fill repository with new ads
    ///
    ///- Precondition
    ///    * Repository not disable
    ///    * Repository not fill
    ///    * Repository contain invalid ads
    ///    * Repository not already in loading
    ///
    /// - Returns: true if start to fill repository otherwise return false
    @discardableResult
    func fillRepoAds()->Bool
    
    
    /// Will remove invalide ads (which comfirm `invalidAdCondition`) instantly
    /// - NOTE: After delete from repository, each ads will delegate `removeFromRepository` function
    func validateRepositoryAds()
    
    /// Will present a full-screen ad if the repository has any
    /// - Parameters:
    ///   - vc: A view controller to present the ad.
    ///   - willLoad: Ad will load as `load From Repo` closure's input
    /// - Returns: Return `true` if can load ads from repository otherwise return `false`
    func presentAd(vc:UIViewController,willLoad:((InterstitialAdWrapper?)->Void)?)->Bool
    
    /// Returns whether the interstitial ad can be presented from the provided root view controller. Sets the error out parameter if the ad can't be presented. Must be called on the main thread.
    /// - Parameter vc: A view controller to present the ad.
    /// - Returns: Return `true` if have any ready to present ad otherwise false
    func canPresentAnyAd(vc:UIViewController)->Bool
    
}
