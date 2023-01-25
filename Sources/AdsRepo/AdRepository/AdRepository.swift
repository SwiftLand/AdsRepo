//
//  AdRepository.swift
//  AdRepo
//
//  Created by ali khajehpour on 10/27/20.
//

import Foundation
import GoogleMobileAds

public typealias InterstitalAdRepository = AdRepository<InterstitialAdWrapper,InterstitialAdLoader>
public typealias RewardedAdRepository = AdRepository<RewardedAdWrapper,RewardedAdLoader>
public typealias NativeAdRepository = AdRepository<NativeAdWrapper,NativeAdLoader>

public class AdRepository<AdWrapperType:AdWrapperProtocol,
                          AdLoaderType:AdLoaderProtocol>:NSObject,AdRepositoryProtocol where AdLoaderType.AdWrapperType == AdWrapperType{

    public var adCount: Int {adsRepo.count}
    
    private var adTimerDict:[String:DispatchSourceTimer] = [:]
    private var errorHandler:ErrorHandlerProtocol
    
    public lazy var adLoader:AdLoaderType = AdLoaderType(config: config)
    
    
    /// Current reposiotry configuration. See **RepositoryConfig.swift** for more details.
    public private(set) var config:AdRepositoryConfig
    
    /// Return `true` if current repository is in loading state
    public var isLoading:Bool {adLoader.state == .loading}
    
    /// Array of `InterstitialAdWrapper` objects
    /// - WARNING:It's a `read-only` variable and it will change inside the repository only
    private(set) var adsRepo:[AdWrapperType] = []
    
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
        config:AdRepositoryConfig,
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
        
        setNotifiers()
        adLoader.load(count: totalAdsNeedCount)

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
        ad?.showCount += 1
        onLoad(ad)
        if autoFill {
            fillRepoAds()
        }
        return true
    }
    
    public func invalidate(ad: AdWrapperType) {
        remove(ad: ad)
        if autoFill {
            fillRepoAds()
        }
    }
    
    public func append(observer: AdRepositoryDelegate) {
        multicastDelegate.append(observer: observer)
    }
    
    public func remove(observer: AdRepositoryDelegate) {
        multicastDelegate.remove(observer: observer)
    }
}

//private functions
extension AdRepository{
    
    private func setNotifiers(){
        adLoader.notifyRepositoryDidReceiveAd = {
            [weak self] ad in
            guard let self = self else{return}
            self.notifyDidReceive(ad: ad)
        }
        adLoader.notifyRepositoryDidFinishLoad = {
            [weak self] error in
            guard let self = self else{return}
            self.notifydidFinishLoad(withError: error)
        }
    }
    
    @discardableResult
    private func append(ad:AdWrapperType)->AdWrapperType{
        adsRepo.append(ad)
        return ad
    }
    
    private func remove(ad:AdWrapperType){
        adsRepo.removeAll(where: {$0 == ad})
        multicastDelegate.delegates.forEach{
            $0.adRepository(didRemove: ad, in: self)
        }
    }
    
    private func removeAll(where condition: ((AdWrapperType) -> Bool)? = nil){
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
}
extension AdRepository{
    
    private func createTimer(for ad:AdWrapperType){
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
    
    private func startTimer(for ad:AdWrapperType){
        adTimerDict[ad.id]?.resume()
    }
    private func cancelTimer(for ad:AdWrapperType){
        adTimerDict[ad.id]?.cancel()
        adTimerDict.removeValue(forKey: ad.id)
    }
}

extension AdRepository{
    
    private func notifyDidReceive(ad:AdWrapperType){
        print("AdRepository","did Receive \(AdWrapperType.self) type ad")
        append(ad:ad)
        createTimer(for: ad)
        startTimer(for: ad)
        multicastDelegate.delegates.forEach{
            $0.adRepository(didReceive: self)
        }
    }
    
    private func notifydidFinishLoad(withError error:Error?){
        if let error = error{
            print("AdRepository","did finish load ads for",AdWrapperType.self,"with error:",error.localizedDescription)
            handleError(error)
            return
        }
        print("AdRepository","did finish load ads for",AdWrapperType.self)
        errorHandler.restart()
        validateRepositoryAds()
        if autoFill{
            fillRepoAds()
        }
        multicastDelegate.delegates.forEach{
            $0.adRepository(didFinishLoading: self, error: error)
        }
    }
    
    private func handleError(_ error: Error) {
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
