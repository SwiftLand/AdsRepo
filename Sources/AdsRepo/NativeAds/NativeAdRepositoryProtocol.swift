//
//  NativeAdRepositoryProtocol.swift
//  AdsRepo
//
//  Created by Ali on 9/17/22.
//

import Foundation
import GoogleMobileAds

public protocol NativeAdRepositoryProtocol:AdsRepoProtocol{

    /// Change any adloader options for next loads
    /// - Parameters:
    ///   - adLoaderOptions: Array of `GADAdLoaderOptions` options
    ///     - WARNING: `GADMultipleAdsAdLoaderOptions` will always override with repository size
    ///   - adTypes: Array of `GADAdLoaderAdType` types
    ///   - rootVC: The root view controller is used to present ad click actions.
    func adLoaderConfig(adLoaderOptions:[GADAdLoaderOptions],
                               adTypes:[GADAdLoaderAdType]?,
                               rootVC:UIViewController?)
    
    
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
    
    
    /// Will load an ad if the repository has any
    ///
    /// Load ads from repository if exists and increase `showcount` for returned ads
    /// - Postcondition: If `autofill` is `true`  (default: `true`) and repository is empty, it will call `fillRepoAds` function automatically
    ///
    /// - Parameter loadFromRepo: Ad will load as `load From Repo` closure's input
    /// - Returns: Return `true` if can load ads from repository otherwise return `false`
    @discardableResult
    func loadAd(loadFromRepo:@escaping ((NativeAdWrapper?)->Void))->Bool
    
    /// Will remove invalide ads (which comfirm `invalidAdCondition`) instantly
    /// - NOTE: After delete from repository, each ads will delegate `removeFromRepository` function
    func validateRepositoryAds()
    
    
    /// Stop loading ads instantly
    ///  - WARNING: It will be reactive If `autofill` is `true`  (default :`true`) after `loadAd` or `fillRepoAds` functions called
    func stopLoading() 
}
