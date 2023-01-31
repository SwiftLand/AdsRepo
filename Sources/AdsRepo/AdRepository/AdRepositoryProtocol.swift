//
//  AdsRepoProtocol.swift
//  AdsRepo
//
//  Created by Ali on 9/17/22.
//

import Foundation

public protocol AdRepositoryProtocol:NSObject {
    
    associatedtype AdWrapperType
    
    associatedtype AdLoaderType
    
    //An object responsible to load ads from the ad provider
    var adLoader:AdLoaderType{get}
    
    /// Current repository configuration. See **AdRepositoryConfig.swift** for more details.
    var config:AdRepositoryConfig {get}
    
    /// Return `true` if current repository is in loading state
    var isLoading:Bool {get}
    
    /// If `true` repository will load new ads automatically when
    /// requiring otherwise you need to call `fillRepoAds` manually.
    var autoFill:Bool {set get}
    
    /// If `true` repository validates ads before loading them (defualt: `false`)
    var loadOnlyValidAd:Bool {set get}
    
    /// If `true` repository keep invalidate ads until new ad arrive them (defualt: `true`)
    /// - NOTE: You can use an ad multiple times before new ads arrive
    var waitForNewAdBeforeRemove:Bool {set get}
    
    /// If `true` repository remove all ads
    /// (also delegate `removeFromRepository` function for eachremoved ad) and never fill repository again even after call `fillRepoAds`,`loadAd` or `presentAd` function.
    /// If `false` and `autofill` is `true`  (default : `true`), It will fill repository with ads
    var isDisable:Bool{set get}
    
    /// Return `true` if the repository contains ads otherwise return `false`
    var hasAd:Bool{get}
    
    /// Return  repository valid total ad count
    var totalAdCount:Int{get}
    
    /// Return `true` if the repository contains valid ads otherwise return `false`
    var hasValidAd:Bool{get}
    
    /// Return  repository valid ad count
    var validAdCount:Int{get}
  
    /// Return `true` if the repository contains Invalid ads otherwise return `false`
    var hasInvalidAd:Bool{get}
    
    /// Return  repository invalid ad count
    var invalidAdCount:Int{get}
    
    ///An object responsible to handle error
    var errorHandler:AdRepositoryErrorHandlerProtocol {get set}
    
    ///An object responsible to handle network connectivity
    var reachability:AdRepositoryReachabilityPorotocol {get set}
    
    /// Condition used to validate ads. if return `true` ad is invalid otherwise is valid
    ///  - NOTE:by default use `showCount` and `expireIntervalTime` to validate ads in repository
    var invalidAdCondition:((AdWrapperType) -> Bool){get set}
    
    ///  Fill repository with new ads
    ///
    ///- Precondition
    ///    * Repository not disable
    ///    * Repository not fill with valid ads
    ///    * Repository contain invalid ads
    ///    * Repository not already in loading
    ///
    /// - Returns: true if start to fill repository otherwise return false
    @discardableResult
    func fillRepoAds()->Bool
    
    ///If the repository has at least one ad (in a user-specified condition), will return that ad otherwise returns `nil`
    func loadAd()->AdWrapperType?
    
    /// Will remove invalid ads (which confirm `invalidAdCondition`) instantly
    /// - NOTE: After delete from repository, each ads will delegate `removeFromRepository` function
    func validateRepositoryAds()
    
    
    ///  Remove input ad and  fill repository with new ads if `autoFill` is `true`
    /// - Parameter ad:an ad object which will remove from the repository
    func invalidate(ad:AdWrapperType)
    
    /// Append delegate to the repository. the repository will call the delegate object when needed
    /// - Parameter delegate:an object which confirms the **AdRepositoryDelegate ** protocol
    func append(delegate:AdRepositoryDelegate)
    
    /// Remove a delegate from the repository.
    /// - Parameter delegate:an object which confirms the **AdRepositoryDelegate ** protocol
    func remove(delegate:AdRepositoryDelegate)
}
