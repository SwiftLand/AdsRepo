//
//  AdsRepoProtocol.swift
//  AdsRepo
//
//  Created by Ali on 9/17/22.
//

import Foundation
public protocol AdsRepoProtocol:NSObject {
    
    /// Current reposiotry configuration. See **RepositoryConfig.swift** for more details.
    var config:RepositoryConfig {get}
    
    /// Return `true` if current repository is in loading state
    var isLoading:Bool {get}
    
    /// If `true` repository will load new ads automaticly when require otherwise you need to to call `fillRepoAds` manually.
    var autoFill:Bool {set get}
    
    /// If `true` repository remove all ads (also delegate `removeFromRepository` function for each removed ad) and never fill repository again even after call `fillRepoAds` or `loadAd` function.
    /// if `false` and `autofill` is `true`  (default : `true`), It will fill repository with ads
    var isDisable:Bool{set get}
    
    /// Return  repository loaded ad count
    var AdCount:Int{get}
    
    /// Return `true` if the repository contains ads otherwise return `false`
    var hasAd:Bool{get}
    
    /// Return `true` if the repository contains valid ads otherwise return `false`
    var hasValidAd:Bool{get}
    
    /// Return  repository invalid ad count
    var invalidAdCount:Int{get}
    
    /// Return  repository valid ad count
    var validAdCount:Int{get}
    
    /// Return `true` if the repository contains Invalid ads otherwise return `false`
     var hasInvalidAd:Bool{get}
    
}
