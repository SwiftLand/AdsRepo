//
//  AdRepository.swift
//  AdRepo
//
//  Created by ali khajehpour on 10/27/20.
//

import Foundation
import GoogleMobileAds


public class AdRepository<AdWrapperType:AdWrapperProtocol>:NSObject,AdRepositoryProtocol{
    
    public var adCount: Int {adsRepo.count}
    
    private var adTimerDict:[String:DispatchSourceTimer] = [:]
    private var errorHandler:ErrorHandlerProtocol
    
    lazy var adLoader:AdLoaderProtocol = AdLoaderFactory<AdWrapperType>().create(config: config, delegate: self)
    
    
    /// Current reposiotry configuration. See **RepositoryConfig.swift** for more details.
    public private(set) var config:RepositoryConfig
    
    /// Return `true` if current repository is in loading state
    public var isLoading:Bool {adLoader.state == .loading}
    
    /// Array of `InterstitialAdWrapper` objects
    /// - WARNING:It's a `read-only` variable and it will change inside the repository only
    private(set) var adsRepo:[any AdWrapperProtocol] = []
    
    /// If `true` repository will load new ads automaticly when require otherwise you need to to call `fillRepoAds` manually.
    public var autoFill:Bool = true
    
    /// If `true` repository remove all ads (also delegate `removeFromRepository` function for each removed ad) and never fill repository again even after call `fillRepoAds` or `loadAd` function.
    /// if `false` and `autofill` is `true`  (default : `true`), It will fill repository with ads
    public var isDisable:Bool = false{
        didSet{
            if isDisable{
                errorHandler.cancel()
                removeAll()
            }else{
                if autoFill {
                    fillRepoAds()
                }
            }
        }
    }
    
    private var multicastDelegate = MulticastDelegate<AdRepositoryDelegate>()
    
    /// Condition to validate ads
    ///  - NOTE:by default use `showCount` and `expireIntervalTime` to validate ads in repository
    open var invalidAdCondition:((any AdWrapperProtocol) -> Bool) = {
        let now = Date().timeIntervalSince1970
        return (now-($0.loadedDate) > $0.config.expireIntervalTime) || $0.showCount>=$0.config.showCountThreshold
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
    public init(
        config:RepositoryConfig,
        errorHandlerConfig:ErrorHandlerConfig? = nil){
            
            self.config = config
            
            if let eConfig = errorHandlerConfig{
                self.errorHandler = ErrorHandler(config:eConfig)
            }
            self.errorHandler = errorHandlerConfig != nil ? ErrorHandler(config: errorHandlerConfig):ErrorHandler()
            
            super.init()
            
            self.errorHandler.delegate = self
        }
    
    
    /// Will remove invalid ads (which comfirm `invalidAdCondition`) instantly
    /// - NOTE: After delete from repository, each ads will delegate `removeFromRepository` function
    public func validateRepositoryAds(){
        let ads = adsRepo.filter(invalidAdCondition)
        adsRepo.removeAll(where: invalidAdCondition)
        ads.forEach{ ad in
            multicastDelegate.delegates.forEach({$0.adRepository(didRemove: ad, in: self)})
        }
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
        guard !isDisable else{return false}
        guard adLoader.state == .waiting else {return false}
        let validCount = validAdCount
        guard (validCount<config.size) else {return false}
       
        let totalAdsNeedCount =  config.size - validCount
        
        adLoader.load(adCount: totalAdsNeedCount)

        return true
    }
    
    @discardableResult
    public func loadAd(onLoad: @escaping (((AdWrapperType)?) -> Void)) -> Bool {
        guard autoFill,adsRepo.count>0 else {
            onLoad(nil)
            fillRepoAds()
            return false
        }
        let ad = adsRepo.min(by: {$0.showCount<$1.showCount})
        ad?.increaseShowCount()
        onLoad(ad as? AdWrapperType)
        if autoFill {
            fillRepoAds()
        }
        return true
    }
}

//internal functions
extension AdRepository{
    
    @discardableResult
    func append(ad:any AdWrapperProtocol)->any AdWrapperProtocol{
        adsRepo.append(ad)
        return ad
    }
    
    private func remove(ad:any AdWrapperProtocol){
        adsRepo.removeAll(where: {$0 == ad})
        multicastDelegate.delegates.forEach{
            $0.adRepository(didRemove: ad, in: self)
        }
    }
    
    private func removeAll(where condition: ((any AdWrapperProtocol) -> Bool)? = nil){
        var ads:[any AdWrapperProtocol] = []
        if let condition = condition {
            ads = adsRepo.filter(condition)
            adsRepo.removeAll(where:condition)
        }else{
            ads = adsRepo
            adsRepo.removeAll()
        }
        
        ads.forEach{
            ad in
            multicastDelegate.delegates.forEach{
                $0.adRepository(didRemove: ad, in: self)
            }
        }
        
    }
    
    public func append(observer: AdRepositoryDelegate) {
        multicastDelegate.append(observer: observer)
    }
    
    public func remove(observer: AdRepositoryDelegate) {
        multicastDelegate.remove(observer: observer)
    }
}
extension AdRepository{
    
    private func createTimer(for ad:any AdWrapperProtocol){
        let timer = DispatchSource.makeTimerSource(queue:DispatchQueue.main)
        timer.schedule(deadline: .now() +  config.expireIntervalTime)
        timer.setEventHandler { [weak self] in
            
            guard let self = self else {return}
            
            self.adTimerDict.removeValue(forKey: ad.id)
            self.multicastDelegate.delegates.forEach{
                $0.adRepository(didExpire: ad, in: self)
            }
            if self.autoFill{
                self.fillRepoAds()
            }
        }
        adTimerDict[ad.id] = timer
    }
    
    private func startTimer(for ad:any AdWrapperProtocol){
        adTimerDict[ad.id]?.resume()
    }
    private func cancelTimer(for ad:any AdWrapperProtocol){
        adTimerDict[ad.id]?.cancel()
        adTimerDict.removeValue(forKey: ad.id)
    }
}

extension AdRepository:AdLoaderDelegate{
    
    func adLoader(_ adLoader: AdLoaderProtocol, didRecive ad: any AdWrapperProtocol) {
        print("AdLoader","did Receive ad")
        append(ad:ad as! AdWrapperType)
        createTimer(for: ad)
        startTimer(for: ad)
        multicastDelegate.delegates.forEach{
            $0.adRepository(didReceive: self)
        }
    }
    
    func adLoader(didFinishLoad adloader:AdLoaderProtocol, withError error: Error?) {
        if let error = error{
            handlerError(adloader, didFailToReceiveAdWithError: error)
            return
        }
        errorHandler.restart()
        validateRepositoryAds()
        if autoFill{
            fillRepoAds()
        }
        multicastDelegate.delegates.forEach{
            $0.adRepository(didFinishLoading: self, error: error)
        }
        
    }
    
    private func handlerError(_ adLoader: AdLoaderProtocol, didFailToReceiveAdWithError error: Error) {
        guard !errorHandler.isRetryAble(error: error), !self.isLoading else {return}
        multicastDelegate.delegates.forEach{
            $0.adRepository(didFinishLoading: self, error: error)
        }
    }
    
}

extension AdRepository:ErrorHandlerDelegate{
    func errorHandler(onRetry count: Int, for error: Error?) {
        if autoFill {
            fillRepoAds()
        }
    }
}
