//
//  NativeAdRepository.swift
//  AdRepo
//
//  Created by Ali on 9/2/21.
//

import Foundation
import GoogleMobileAds


public class NativeAdRepository:NSObject,NativeAdRepositoryProtocol, AdsRepoDelegate{
 
    
    internal var errorHandler:ErrorHandler = ErrorHandler()
    internal var adCreator:AdCreatorProtocol = AdCreator()
    internal var adLoaderCreator:AdLoaderCreatorProtocol = AdLoaderCreator()
   
    
    /// Current reposiotry configuration. See **RepositoryConfig.swift** for more details.
    public private(set) var config:RepositoryConfig
    
    
    /// Array of `NativeAdWrapper` objects
    /// - WARNING:It's a `read-only` variable and it will change inside the repository only
    fileprivate(set) var adsRepo:[NativeAdWrapper] = []
    
    /// Array of `GADAdLoaderOptions` options
    ///     - WARNING: `GADMultipleAdsAdLoaderOptions` will always override with repository size
    public private(set) var adLoaderOptions: [GADAdLoaderOptions]?
    
    /// Array of `GADAdLoaderAdType` types
    public private(set) var adTypes:[GADAdLoaderAdType]?
    
    /// If `true` repository will load new ads automaticly when require otherwise you need to to call `fillRepoAds` manually.
    public var autoFill:Bool = true
    
    /// Return `true` if current repository is in loading state
    public  var isLoading:Bool {
        adLoader?.isLoading ?? false
    }
    
    /// If `true` repository remove all ads (also delegate `removeFromRepository` function for each removed ad) and never fill repository again even after call `fillRepoAds` or `loadAd` function.
    /// if `false` and `autofill` is `true`  (default : `true`), It will fill repository with ads
    public  var isDisable:Bool = false{
        didSet{
            if isDisable{
                let ads = adsRepo
                adsRepo.removeAll()
                ads.forEach({$0.removeFromRepository()})
            }else{
                if autoFill {
                    fillRepoAds()
                }
            }
        }
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
    
    /// listen to this repository changes
    ///  - NOTE: You can also use **`AdsRepo.share`** to listen to all repositories changes
    public weak var delegate:NativeAdRepositoryDelegate? = nil
    
    /// Condition to validate ads
    ///  - NOTE:by default use `showCount` and `expireIntervalTime` to validate ads in repository
    open var invalidAdCondition:((NativeAdWrapper) -> Bool) = {
        return ($0.now-$0.loadedDate > $0.config.expireIntervalTime) || $0.showCount>=$0.config.showCountThreshold
        
    }
    
    private weak var rootVC:UIViewController? = nil
    private var adLoader: GADAdLoader?
    private lazy var listener:AdLoaderListener = {
        AdLoaderListener(owner: self)
    }()
    
    
    
    /// Create new `NativeAdsRepository`
    /// - Parameters:
    ///   - config: current reposiotry configuration. you can't change it after intial repository. See **RepositoryConfig.swift** for more details.
    ///   - errorHandlerConfig: current reposiotry  error handler configuration  See **ErrorHandlerConfig.swift** for more details.
    ///   - delegate: set delegation for this repository
    public init(config:RepositoryConfig,
                errorHandlerConfig:ErrorHandlerConfig? = nil,
                delegate:NativeAdRepositoryDelegate? = nil){
        
        self.delegate = delegate
        self.config = config
        if let eConfig = errorHandlerConfig{
            self.errorHandler = ErrorHandler(config:eConfig)
        }
        super.init()
        AdsRepo.default.repositories.append(Weak(self))
    }
    
    deinit{
        AdsRepo.default.repositories.removeAll(where: {$0.value == self})
    }
    
    /// Change any adloader options for next loads
    /// - Parameters:
    ///   - adLoaderOptions: Array of `GADAdLoaderOptions` options
    ///     - WARNING: `GADMultipleAdsAdLoaderOptions` will always override with repository size
    ///   - adTypes: Array of `GADAdLoaderAdType` types
    ///   - rootVC: The root view controller is used to present ad click actions.
    public func adLoaderConfig(adLoaderOptions:[GADAdLoaderOptions],
                               adTypes:[GADAdLoaderAdType]? = nil,
                               rootVC:UIViewController? = nil){
        // Create multiple ads ad loader options
        self.adLoaderOptions = adLoaderOptions
        self.rootVC = rootVC
        configAdLoader()
    }
    
    private func configAdLoader(){
     
        var adLoaderOptions = adLoaderOptions ?? []
        
        //multiAdOption have to control from repository
        adLoaderOptions.removeAll(where:{$0 is GADMultipleAdsAdLoaderOptions})
        let multiAdOption = GADMultipleAdsAdLoaderOptions()
        multiAdOption.numberOfAds = config.size - adsRepo.count
        adLoaderOptions.append(multiAdOption)
        
        
        let vc = rootVC ?? UIApplication.shared.keyWindow?.rootViewController
        // Create GADAdLoader
        adLoader = adLoaderCreator.create(adUnitId: config.adUnitId,
                                          rootViewController: vc,
                                          adLoaderOptions: adLoaderOptions,
                                          adTypes: adTypes)
        // Set the GADAdLoader delegate
        adLoader?.delegate = listener
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
        guard !isDisable else {return false}
        
        guard adsRepo.count < config.size || adsRepo.contains(where: invalidAdCondition)
        else {return false}
        
        guard !(adLoader?.isLoading ?? false) else{return false}
        
        configAdLoader()
        adLoader?.load(GADRequest())
        return true
    }
    
    
    /// Will load an ad if the repository has any
    ///
    /// Load ads from repository if exists and increase `showcount` for returned ads
    /// - Postcondition: If `autofill` is `true`  (default: `true`) and repository is empty, it will call `fillRepoAds` function automatically
    ///
    /// - Parameter loadFromRepo: Ad will load as `load From Repo` closure's input
    /// - Returns: Return `true` if can load ads from repository otherwise return `false`
    @discardableResult
    public func loadAd(loadFromRepo:@escaping ((NativeAdWrapper?)->Void))->Bool{
        
        guard autoFill,adsRepo.count>0 else {
            loadFromRepo(nil)
            fillRepoAds()
            return false
        }
        
        let ad = adsRepo.min(by: {$0.showCount<$1.showCount})
        ad?.increaseShowCount()
        loadFromRepo(ad)
        notifyAdChange()
        return true
    }
    
    /// Will remove invalide ads (which comfirm `invalidAdCondition`) instantly
    /// - NOTE: After delete from repository, each ads will delegate `removeFromRepository` function
    public func validateRepositoryAds(){
        let ads = adsRepo.filter(invalidAdCondition)
        adsRepo.removeAll(where: invalidAdCondition)
        ads.forEach({$0.removeFromRepository()})
    }
    
    private func removeAd(ad: NativeAdWrapper){//call when ad expire
          adsRepo.removeAll(where: {$0 == ad})
          ad.removeFromRepository()
    }
    
    private  func notifyAdChange(){
        if autoFill{
            fillRepoAds()
        }
    }
    
    /// Stop loading ads instantly
    ///  - WARNING: It will be reactive If `autofill` is `true`  (default :`true`) after `loadAd` or `fillRepoAds` functions called
    public func stopLoading() {
        errorHandler.cancel()
        adLoader?.delegate = nil
        adLoader = nil
    }
}

extension NativeAdRepository:NativeAdOwnerDelegate{
    func adWrapper(didExpire ad: NativeAdWrapper) {
        notifyAdChange()
    }
}

private class AdLoaderListener:NSObject,GADNativeAdLoaderDelegate{
    weak var owner:NativeAdRepository?
    init(owner:NativeAdRepository) {
        self.owner = owner
    }
    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADNativeAd) {
        print("Native AdLoader","did Receive ads")
        guard let owner = owner else {return}
        
        owner.adsRepo.append(owner.adCreator.createAd(loadedAd: nativeAd,owner: owner))
        owner.delegate?.nativeAdRepository(didReceive: owner)
        AdsRepo.default.nativeAdRepository(didReceive: owner)
    }
    
    func adLoaderDidFinishLoading(_ adLoader: GADAdLoader) {
        print("Native AdLoader","DidFinishLoading")
        guard let owner = owner else {return}
        owner.errorHandler.restart()
        owner.validateRepositoryAds()
        if !owner.autoFill || !owner.fillRepoAds(){
            owner.delegate?.nativeAdRepository(didFinishLoading:owner,error:nil)
            AdsRepo.default.nativeAdRepository(didFinishLoading:owner,error:nil)
        }
    }
    
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
        print("Native AdLoader","error:",error)
        guard let owner = owner else {return}
        
        if owner.errorHandler.isRetryAble(error: error),!owner.isLoading{
            if owner.autoFill {
                owner.fillRepoAds()
            }
        }else{
            owner.delegate?.nativeAdRepository(didFinishLoading:owner, error: error)
            AdsRepo.default.nativeAdRepository(didFinishLoading:owner, error: error)
        }
    }
}
