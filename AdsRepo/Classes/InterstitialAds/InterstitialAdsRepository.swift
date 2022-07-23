//
//  InterstitialAdContoller.swift
//  WidgetBox
//
//  Created by ali khajehpour on 10/27/20.
//

import Foundation
import GoogleMobileAds

public protocol InterstitialAdsRepositoryDelegate:NSObject {
    func interstitialAdsRepository(didReceive repo:InterstitialAdsRepository)
    func interstitialAdsRepository(didFinishLoading repo:InterstitialAdsRepository,error:Error?)
}

extension InterstitialAdsRepositoryDelegate {
    public func interstitialAdsRepository(didReceive repo:InterstitialAdsRepository){}
    public func interstitialAdsRepository(didFinishLoading repo:InterstitialAdsRepository,error:Error?){}
}

public class InterstitialAdsRepository:NSObject,AdsRepoProtocol{

    public let identifier:String
    private var errorHandler:ErrorHandler
    public var isLoading:Bool {adsRepo.contains(where: {$0.isLoading})}
    public private(set) var adsRepo:[InterstitialAdWrapper] = []
    public private(set) var config:RepoConfig
    public var autoFill:Bool = true
    public var isDisable:Bool = false{
        didSet{
            if isDisable{
                errorHandler.cancel()
                adsRepo.removeAll()
            }else{
                if autoFill {
                    fillRepoAds()
                }
            }
        }
    }
   weak var delegate:InterstitialAdsRepositoryDelegate? = nil
    
    public init(identifier:String,config:RepoConfig,
         errorHandlerConfig:ErrorHandlerConfig? = nil,
         delegate:InterstitialAdsRepositoryDelegate? = nil){
        self.identifier = identifier
        self.config = config
        self.delegate = delegate
        self.errorHandler = ErrorHandler(config:errorHandlerConfig)
        super.init()
    }
    
    public func fillRepoAds(){
         guard !isDisable else{return}
          let loadingAdsCount = adsRepo.filter({$0.isLoading}).count
          let totalAdsNeedCount = config.repoSize-loadingAdsCount
          while adsRepo.count<totalAdsNeedCount{
            adsRepo.append(InterstitialAdWrapper(owner: self))
            adsRepo.last?.loadAd()
          }
      }

 public func presentAd(vc:UIViewController){
    let now = Date().timeIntervalSince1970
    guard let adWrapper = adsRepo.min(by: {($0.loadedDate ?? now) < ($1.loadedDate ?? now)})
    else{return}
      adWrapper.presentAd(vc: vc)
    }
    
 public func hasReadyAd(vc:UIViewController)->Bool{
      return  adsRepo.first(where: {$0.isReady(vc: vc)}) != nil
    }

}

extension InterstitialAdsRepository{

    func interstitialAd(didReady ad:InterstitialAdWrapper) {
        errorHandler.restart()
        delegate?.interstitialAdsRepository(didReceive: self)
        AdsRepo.default.interstitialAdsRepository(didReceive: self)
        if !adsRepo.contains(where: {!$0.isLoaded}){
            delegate?.interstitialAdsRepository(didFinishLoading: self, error: nil)
            AdsRepo.default.interstitialAdsRepository(didFinishLoading: self, error: nil)
        }
    }
    
    func interstitialAd(didClose ad:InterstitialAdWrapper) {
        adsRepo.removeAll(where: {$0.showCount>0})
        if autoFill {
            fillRepoAds()
        }
    }
    
    func interstitialAd(onError ad:InterstitialAdWrapper, error: Error?) {
        adsRepo.removeAll(where: {$0 == ad})
        if errorHandler.isRetryAble(error: error),!isLoading{
            fillRepoAds()
        }else{
            delegate?.interstitialAdsRepository(didFinishLoading: self, error: error)
            AdsRepo.default.interstitialAdsRepository(didFinishLoading: self, error: error)
        }
    }
    func interstitialAd(didExpire ad: InterstitialAdWrapper) {
        adsRepo.removeAll(where: {$0 == ad})
        if autoFill {
          fillRepoAds()
        }
    }
}

