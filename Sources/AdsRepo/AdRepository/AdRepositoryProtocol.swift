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
    
    var adLoader:AdLoaderType{get}
    
    /// Current repository configuration. See **RepositoryConfig.swift** for more details.
    var config:AdRepositoryConfig {get}
    
    /// Return `true` if current repository is in loading state
    var isLoading:Bool {get}
    
    /// If `true` repository will load new ads automatically when
    /// requiring otherwise you need to call `fillRepoAds` manually.
    var autoFill:Bool {set get}
    
    /// If `true` repository remove all ads
    /// (also delegate `removeFromRepository` function for eachremoved ad) and never fill repository again even after call `fillRepoAds`,`loadAd` or `presentAd` function.
    /// If `false` and `autofill` is `true`  (default : `true`), It will fill repository with ads
    var isDisable:Bool{set get}
    
    /// Return `true` if the repository contains ads otherwise return `false`
    var hasAd:Bool{get}
    
    /// Return `true` if the repository contains valid ads otherwise return `false`
    var hasValidAd:Bool{get}
    
    /// Return  repository valid total ad count
    var adCount:Int{get}
    
    /// Return  repository invalid ad count
    var invalidAdCount:Int{get}
    
    /// Return  repository valid ad count
    var validAdCount:Int{get}
    
    /// Return `true` if the repository contains Invalid ads otherwise return `false`
    var hasInvalidAd:Bool{get}
    
    ///  Fill repository with new ads
    ///
    ///- Precondition
    ///    * Repository not disable
    ///    * Repository not fill
    ///    * Repository contain invalid ads
    ///    * Repository not already in loading
    ///
    /// - Returns: `true` if start to fill repository otherwise, return `false`
    @discardableResult
    func fillRepoAds()->Bool
    
    @discardableResult
    func loadAd(onLoad: @escaping ((AdWrapperType?) -> Void)) -> Bool
    
    /// Will remove invalid ads (which confirm `invalidAdCondition`) instantly
    /// - NOTE: After being deleted from the repository, each ad will
    /// delegate `removeFromRepository` function
    func validateRepositoryAds()
    
    func invalidate(ad:AdWrapperType)
    
    func append(observer:AdRepositoryDelegate)
    
    func remove(observer:AdRepositoryDelegate)
}
