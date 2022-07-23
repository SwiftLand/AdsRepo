//
//  InterstitialAdContoller.swift
//  WidgetBox
//
//  Created by ali khajehpour on 10/27/20.
//

import Foundation
import GoogleMobileAds

public protocol InterstitialAdsControllerDelegate:NSObject {
    func interstitialAdsController(didReceive repo:InterstitialAdsController)
    func interstitialAdsController(didFinishLoading repo:InterstitialAdsController,error:Error?)
}

extension InterstitialAdsControllerDelegate {
    public func interstitialAdsController(didReceive repo:InterstitialAdsController){}
    public func interstitialAdsController(didFinishLoading repo:InterstitialAdsController,error:Error?){}
}

public class InterstitialAdsController:NSObject,AdsRepoProtocol{
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
   weak var delegate:InterstitialAdsControllerDelegate? = nil
    
public init(config:RepoConfig,
         errorHandlerConfig:ErrorHandlerConfig? = nil,
         delegate:InterstitialAdsControllerDelegate? = nil){
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

extension InterstitialAdsController{

    func interstitialAd(didReady ad:InterstitialAdWrapper) {
        errorHandler.restart()
        delegate?.interstitialAdsController(didReceive: self)
        AdsRepo.default.interstitialAdsController(didReceive: self)
        if !adsRepo.contains(where: {!$0.isLoaded}){
            delegate?.interstitialAdsController(didFinishLoading: self, error: nil)
            AdsRepo.default.interstitialAdsController(didFinishLoading: self, error: nil)
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
            delegate?.interstitialAdsController(didFinishLoading: self, error: error)
            AdsRepo.default.interstitialAdsController(didFinishLoading: self, error: error)
        }
    }
    func interstitialAd(didExpire ad: InterstitialAdWrapper) {
        adsRepo.removeAll(where: {$0 == ad})
        if autoFill {
          fillRepoAds()
        }
    }
}

