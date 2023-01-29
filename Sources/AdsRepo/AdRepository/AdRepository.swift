//
//  AdRepository.swift
//  AdRepo
//
//  Created by ali khajehpour on 10/27/20.
//

import Foundation

public typealias InterstitalAdRepository = AdRepository<GADInterstitialAdWrapper,InterstitialAdLoader>
public typealias RewardedAdRepository = AdRepository<GADRewardedAdWrapper,RewardedAdLoader>
public typealias NativeAdRepository = AdRepository<GADNativeAdWrapper,NativeAdLoader>

public final class AdRepository<AdWrapperType:AdWrapperProtocol,
                          AdLoaderType:AdLoaderProtocol>:NSObject,AdRepositoryProtocol where AdLoaderType.AdWrapperType == AdWrapperType{
    
    
  
    public private(set) lazy var adLoader:AdLoaderType = AdLoaderType(config: config)
    public var errorHandler:AdRepositoryErrorHandlerProtocol = AdRepositoryErrorHandler()
    public var reachability:AdRepositoryReachabilityPorotocol = ReachabilityWrapper()
    
    /// Current reposiotry configuration. See **RepositoryConfig.swift** for more details.
    public private(set) var config:AdRepositoryConfig
    
    /// Return `true` if current repository is in loading state
    public var isLoading:Bool {adLoader.state == .loading}
    
    /// Return `true` if the repository contains ads otherwise return `false`
    public var hasAd:Bool{
        return adsRepo.count > 0
    }
    public var currentAdCount: Int {adsRepo.count}
    
    
    /// Return  repository valid ad count
    public  var validAdCount:Int{
        adsRepo.filter({!invalidAdCondition($0)}).count
    }
    /// Return `true` if the repository contains valid ads otherwise return `false`
    public var hasValidAd:Bool{
        adsRepo.contains(where: {!invalidAdCondition($0)})
    }
    
    /// Return  repository invalid ad count
    public var invalidAdCount:Int{
        adsRepo.filter({invalidAdCondition($0)}).count
    }
    
    /// Return `true` if the repository contains Invalid ads otherwise return `false`
    public var hasInvalidAd:Bool{
        return adsRepo.contains(where: invalidAdCondition)
    }
   
    /// Condition to validate ads
    ///  - NOTE:by default use `showCount` and `expireIntervalTime` to validate ads in repository
    public var invalidAdCondition:((AdWrapperType) -> Bool) = {
        let now = Date.current.timeIntervalSince1970
        return (now-($0.loadedDate) > $0.config.expireIntervalTime) || $0.showCount>=$0.config.showCountThreshold
    }
    
    /// If `true` repository will load new ads automaticly when require otherwise you need to to call `fillRepoAds` manually.
    public var autoFill:Bool = true
    public var loadOnlyValidAd:Bool = false
    public var waitForNewAdBeforeRemove:Bool = true
    
    
    /// If `true` repository remove all ads (also delegate `removeFromRepository` function for each removed ad) and never fill repository again even after call `fillRepoAds` or `loadAd` function.
    /// if `false` and `autofill` is `true`  (default : `true`), It will fill repository with ads
    public var isDisable:Bool = false{
        didSet{
            if isDisable{
                errorHandler.cancel()
                removeAll()
            }else{
                fillRepoAdsIfAutoFillEnable()
            }
        }
    }
 

    internal var adsRepo:[AdWrapperType] = []
    internal var multicastDelegate = MulticastDelegate<AdRepositoryDelegate>()
    internal var adTimerDict:[String:DispatchSourceTimer] = [:]
    
    /// Create new `InterstitialAdRepository`
    /// - Parameters:
    ///   - config: current reposiotry configuration. you can't change it after intial repository. See **RepositoryConfig.swift** for more details.
    ///   - errorHandlerConfig: current reposiotry  error handler configuration  See **ErrorHandlerConfig.swift** for more details.
    ///   - delegate: set delegation for this repository
    public init(config:AdRepositoryConfig){
            self.config = config
    }
    
    /// Will remove invalid ads (which comfirm `invalidAdCondition`) instantly
    /// - NOTE: After delete from repository, each ads will delegate `removeFromRepository` function
    public func validateRepositoryAds(){
        removeAll(where: invalidAdCondition)
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
        guard reachability.isConnected else {
            waitForConnection()
            return false
        }
        
        let validCount = validAdCount
        guard (validCount<config.size) else {return false}
        
        let totalAdsNeedCount =  config.size - validCount
        
        setNotifiers()
        adLoader.load(count: totalAdsNeedCount)
        
        return true
    }
    
    public func loadAd()->AdWrapperType? {
        
        if loadOnlyValidAd {
            validateRepositoryAds()
        }
        
        guard adsRepo.count>0 else {
            fillRepoAdsIfAutoFillEnable()
            return nil
        }
        
        let ad = adsRepo.min(by: {$0.showCount<$1.showCount})
        ad?.showCount += 1
        
        if !waitForNewAdBeforeRemove {
            validateRepositoryAds()
        }
        
        fillRepoAdsIfAutoFillEnable()
        
        return ad
    }
    
    public func invalidate(ad: AdWrapperType) {
        remove(ad: ad)
        fillRepoAdsIfAutoFillEnable()
    }
    
    public func append(delegate: AdRepositoryDelegate) {
        multicastDelegate.append(delegate: delegate)
    }
    
    public func remove(delegate: AdRepositoryDelegate) {
        multicastDelegate.remove(delegate: delegate)
    }
}

//MARK: Private setction

extension AdRepository{
    
    private func fillRepoAdsIfAutoFillEnable(){
        if autoFill{
            fillRepoAds()
        }
    }
    
    private func waitForConnection(){
        
        reachability.setBackOnlineNotifier{[weak self] reachability in
    
            reachability.stopNotifier()
            self?.fillRepoAdsIfAutoFillEnable()
        }
        reachability.startNotifier()
    }
    
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
        removeFirst(where: {$0 == ad})
    }
    
    private func removeFirst(where condition: ((AdWrapperType) -> Bool)){
        guard let removedIndex = adsRepo.firstIndex(where: condition) else {return}
        let removedAd = adsRepo.remove(at: removedIndex)
        cancelTimer(for: removedAd)
        notifyRemoveObservers([removedAd])
    }
    
    private func removeAll(where condition: ((AdWrapperType) -> Bool)? = nil){
        var removedads:[AdWrapperType] = []
        
        if let condition = condition {
            removedads = adsRepo.filter(condition)
            adsRepo.removeAll(where:condition)
        }else{
            removedads = adsRepo
            adsRepo.removeAll()
        }
        
        for removedAd in removedads{
            cancelTimer(for: removedAd)
        }
        notifyRemoveObservers(removedads)
    }
    
    private func notifyRemoveObservers(_ ads:[AdWrapperType]){
        for ad in ads{
            multicastDelegate.invoke{
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
            
            self.adTimerDict.removeValue(forKey: ad.uniqueId)

            self.multicastDelegate.invoke{
                $0.adRepository(didExpire: ad, in: self)
            }
            
            self.fillRepoAdsIfAutoFillEnable()
        }
        adTimerDict[ad.uniqueId] = timer
    }
    
    private func startTimer(for ad:AdWrapperType){
        adTimerDict[ad.uniqueId]?.resume()
    }
    private func cancelTimer(for ad:AdWrapperType){
        adTimerDict[ad.uniqueId]?.cancel()
        adTimerDict.removeValue(forKey: ad.uniqueId)
    }
}

extension AdRepository{
    
    private func notifyDidReceive(ad:AdWrapperType){
        print("AdRepository","did Receive \(AdWrapperType.self) type ad")
        removeFirst(where: invalidAdCondition)
        append(ad:ad)
        createTimer(for: ad)
        startTimer(for: ad)

        multicastDelegate.invoke{
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
        fillRepoAdsIfAutoFillEnable()

        multicastDelegate.invoke{
            $0.adRepository(didFinishLoading: self, error: error)
        }
    }
    
    private func handleError(_ error: Error) {
        
        guard !errorHandler.isRetryAble(error: error) else {
            if !isLoading {
                errorHandler.requestForRetry{[weak self] count in
                    print("AdRepository","retry load ads for",AdWrapperType.self,"retry number:",count)
                    self?.fillRepoAdsIfAutoFillEnable()
                }
            }
            return
        }
        
        multicastDelegate.invoke{
            $0.adRepository(didFinishLoading: self, error: error)
        }
    }
    
}
