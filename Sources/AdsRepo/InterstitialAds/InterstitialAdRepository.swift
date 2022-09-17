//
//  InterstitialAdContoller.swift
//  AdRepo
//
//  Created by ali khajehpour on 10/27/20.
//

import Foundation
import GoogleMobileAds


public class InterstitialAdRepository:NSObject,InterstitialAdRepositoryProtocol{

   
    internal var errorHandler:ErrorHandlerProtocol = ErrorHandler()
    internal var adCreator:AdCreatorProtocol = AdCreator()
    
    /// Current reposiotry configuration. See **RepositoryConfig.swift** for more details.
    public private(set) var config:RepositoryConfig
    
    /// Return `true` if current repository is in loading state
    public var isLoading:Bool {adsRepo.contains(where: {$0.state == .loading})}
    
    /// Array of `InterstitialAdWrapper` objects
    /// - WARNING:It's a `read-only` variable and it will change inside the repository only
    private(set) var adsRepo:[InterstitialAdWrapper] = []
    
    /// If `true` repository will load new ads automaticly when require otherwise you need to to call `fillRepoAds` manually.
    public var autoFill:Bool = true
    
    /// If `true` repository remove all ads (also delegate `removeFromRepository` function for each removed ad) and never fill repository again even after call `fillRepoAds` or `loadAd` function.
    /// if `false` and `autofill` is `true`  (default : `true`), It will fill repository with ads
    public var isDisable:Bool = false{
        didSet{
            if isDisable{
                errorHandler.cancel()
                removeAllAds()
            }else{
                if autoFill {
                    fillRepoAds()
                }
            }
        }
    }
    /// listen to this repository changes
    ///  - NOTE: You can also use **`AdsRepo.share`** to listen to all repositories changes
    weak var delegate:InterstitialAdRepositoryDelegate? = nil
    
    /// Condition to validate ads
    ///  - NOTE:by default use `showCount` and `expireIntervalTime` to validate ads in repository
    open var invalidAdCondition:((InterstitialAdWrapper) -> Bool) = {
        
        return ($0.now-($0.loadedDate ?? $0.now) > $0.config.expireIntervalTime) || $0.showCount>=$0.config.showCountThreshold
    }
    /// Return  repository loaded ad count
    public var AdCount:Int{
        return adsRepo.count
    }
    
    /// Return `true` if the repository contains ads otherwise return `false`
    public var hasAd:Bool{
        return adsRepo.count > 0
    }
    
    /// Return `true` if the repository contains valid ads otherwise return `false`
    public var hasValidAd:Bool{
        adsRepo.contains(where: {!invalidAdCondition($0)})
    }
    
    /// Return  repository invalid ad count
    public  var invalidAdCount:Int{
        adsRepo.filter({invalidAdCondition($0)}).count
    }
    
    /// Return  repository valid ad count
    public  var validAdCount:Int{
        adsRepo.filter({!invalidAdCondition($0)}).count
    }
    
    /// Return `true` if the repository contains Invalid ads otherwise return `false`
    public var hasInvalidAd:Bool{
        return adsRepo.contains(where: invalidAdCondition)
    }
    
    /// Create new `InterstitialAdRepository`
    /// - Parameters:
    ///   - config: current reposiotry configuration. you can't change it after intial repository. See **RepositoryConfig.swift** for more details.
    ///   - errorHandlerConfig: current reposiotry  error handler configuration  See **ErrorHandlerConfig.swift** for more details.
    ///   - delegate: set delegation for this repository
    public init(config:RepositoryConfig,
                errorHandlerConfig:ErrorHandlerConfig? = nil,
                delegate:InterstitialAdRepositoryDelegate? = nil){
        
        self.config = config
        self.delegate = delegate
        
        if let eConfig = errorHandlerConfig{
            self.errorHandler = ErrorHandler(config:eConfig)
        }
        
        super.init()
        AdsRepo.default.repositories.append(Weak(self))
    }
    
    deinit{
        AdsRepo.default.repositories.removeAll(where: {$0.value == self})
    }
    
    /// Will remove invalide ads (which comfirm `invalidAdCondition`) instantly
    /// - NOTE: After delete from repository, each ads will delegate `removeFromRepository` function
    public func validateRepositoryAds(){
        let ads = adsRepo.filter(invalidAdCondition)
        adsRepo.removeAll(where: invalidAdCondition)
        ads.forEach({$0.delegate?.interstitialAdWrapper(didRemoveFromRepository: $0)})
    }
    
    private func removeAd(ad: InterstitialAdWrapper){
        adsRepo.removeAll(where: {$0 == ad})
        ad.delegate?.interstitialAdWrapper(didRemoveFromRepository: ad)
    }
    
    private func removeAllAds(where condition: ((InterstitialAdWrapper) -> Bool)? = nil){
        var ads:[InterstitialAdWrapper] = []
        if let condition = condition {
            ads = adsRepo.filter(condition)
            adsRepo.removeAll(where:condition)
        }else{
            ads = adsRepo
            adsRepo.removeAll()
        }
        ads.forEach({$0.delegate?.interstitialAdWrapper(didRemoveFromRepository: $0)})
    }
    
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
    public func fillRepoAds()->Bool{
        var canFill = false
        guard !isDisable else{return canFill}
        let loadingAdsCount = adsRepo.filter({$0.state == .loading}).count
        let notValidAdsCount = adsRepo.filter(invalidAdCondition).count
        let totalAdsNeedCount = (config.size - loadingAdsCount) + notValidAdsCount
        while adsRepo.count<totalAdsNeedCount {
            let ad = adCreator.createAd(owner: self)
            adsRepo.append(ad)
            ad.loadAd()
            canFill = true
        }
        return canFill
    }
   
    
    /// Will present a full-screen ad if the repository has any
    /// - Parameters:
    ///   - vc: A view controller to present the ad.
    ///   - willLoad: Ad will load as `load From Repo` closure's input
    /// - Returns: Return `true` if can load ads from repository otherwise return `false`
    @discardableResult
    public func presentAd(vc:UIViewController,willLoad:((InterstitialAdWrapper?)->Void)? = nil)->Bool{
        let readyAds =  adsRepo.filter({$0.canPresent(vc: vc)})
        guard readyAds.count>0 ,
              let adWrapper = readyAds.min(by: {$0.showCount < $1.showCount})
        else{
            willLoad?(nil)
            if autoFill{
                fillRepoAds()
            }
            return false
        }
        adWrapper.increaseShowCount()
        willLoad?(adWrapper)
        adWrapper.presentAd(vc: vc)
        
        if autoFill{
            fillRepoAds()
        }
        return true
    }
    
    /// Returns whether the interstitial ad can be presented from the provided root view controller. Sets the error out parameter if the ad can't be presented. Must be called on the main thread.
    /// - Parameter vc: A view controller to present the ad.
    /// - Returns: Return `true` if have any ready to present ad otherwise false
    public func canPresentAnyAd(vc:UIViewController)->Bool{
        return  adsRepo.first(where: {$0.canPresent(vc: vc)}) != nil
    }
    
}


extension InterstitialAdRepository:InterstitialAdOwnerDelegate{
    
    func adWrapper(didReady ad:InterstitialAdWrapper) {
        errorHandler.restart()
        if let ad = adsRepo.first(where: {invalidAdCondition($0) && !$0.isPresenting}) {
            removeAd(ad: ad)
        }
        delegate?.interstitialAdRepository(didReceive: self)
        AdsRepo.default.interstitialAdRepository(didReceive: self)

        if !adsRepo.contains(where: {$0.state != .loaded}) && validAdCount == config.size{
            delegate?.interstitialAdRepository(didFinishLoading: self, error: nil)
            AdsRepo.default.interstitialAdRepository(didFinishLoading: self, error: nil)
        }
    }
    
    func adWrapper(didClose ad:InterstitialAdWrapper) {
        if let ad = adsRepo.first(where: invalidAdCondition) {
            removeAd(ad: ad)
        }
    }
    
    func adWrapper(onError ad:InterstitialAdWrapper, error: Error?) {
        removeAd(ad: ad)
        let isRetryAble = errorHandler.isRetryAble(error: error){[weak self] in
            self?.fillRepoAds()//add new ads but not load them
        }
        
        guard !isRetryAble  else{return}
        
        if  !adsRepo.contains(where: {$0.state != .error}){//if load all ads failed
            removeAllAds(where: {$0.state == .error})
            delegate?.interstitialAdRepository(didFinishLoading: self, error: error)
            AdsRepo.default.interstitialAdRepository(didFinishLoading: self, error: error)
        }
        
    }
    func adWrapper(didExpire ad: InterstitialAdWrapper) {
        if autoFill {
            fillRepoAds()
        }
    }
}
