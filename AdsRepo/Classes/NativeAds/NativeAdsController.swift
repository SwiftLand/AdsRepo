//
//  NativeAdsController.swift
//  WidgetBox
//
//  Created by Ali on 9/2/21.
//

import Foundation
import GoogleMobileAds


class NativeAdsController:NSObject{
    static let `default` = NativeAdsController()
    private(set) var repoConfig:RepoConfig? = nil
    var isConfig:Bool{return repoConfig != nil}
    private(set) var adsRepo:[NativeAdWrapper] = []
    var isDisable:Bool = false{
        didSet{
            if isDisable{
                adsRepo.removeAll()
            }
        }
    }
    var delegate:AdsRepoDelegate? = nil
    private var adLoader: GADAdLoader?
    private var onCompleteLoading:(()->Void)? = nil
    
    
    init(delegate:AdsRepoDelegate? = nil){
        super.init()
        self.delegate = delegate
    }
    
    func config(_ config:RepoConfig? = nil,rootVC:UIViewController? = nil){
        // Create multiple ads ad loader options
        
        guard let config = config else {
            self.repoConfig = nil
            self.adLoader = nil
            return
        }
        self.repoConfig = config
        var adLoaderOptions: [GADAdLoaderOptions]? {
            let multiAdOption = GADMultipleAdsAdLoaderOptions()
            multiAdOption.numberOfAds = config.repoSize
            
            let videoOption = GADVideoOptions()
            videoOption.startMuted = true
            videoOption.customControlsRequested = true
            videoOption.clickToExpandRequested = true
            return [multiAdOption,videoOption]
        }
        
        // Create GADAdLoader
        adLoader = GADAdLoader(
            adUnitID:config.adUnitId,
            rootViewController: rootVC,
            adTypes: [.native],
            options: adLoaderOptions
        )
        
        // Set the GADAdLoader delegate
        adLoader?.delegate = self
    }
    
    func fillRepoAds(){
        guard !isDisable else {return}
        guard let repoConfig = repoConfig else {return}
        guard adsRepo.count<repoConfig.repoSize else {return}
        guard let adLoader = adLoader, !adLoader.isLoading else{return}
        adLoader.load(GADRequest())
    }
    
    func loadAd(onAdReay:@escaping ((NativeAdWrapperProtocol?)->Void)){
        if let lessShowCount = adsRepo.min(by: {$0.showCount<$1.showCount}) {
            lessShowCount.showCount += 1
            onAdReay(lessShowCount)
            return
        }
        if let adLoader = adLoader, !adLoader.isLoading{
            fillRepoAds()
        }else{
            print("Native AdLoader","in loading")
        }
        onAdReay(nil)
    }
}

extension NativeAdsController: GADNativeAdLoaderDelegate {
    
    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADNativeAd) {
        guard let repoConfig = repoConfig else {return}
        guard !isDisable else {return}
        adsRepo.append(NativeAdWrapper(repoConfig: repoConfig, loadedAd: nativeAd))
        print("Native AdLoader","did Receive ads")
        delegate?.didReceiveNativeAds()
    }
    
    func adLoaderDidFinishLoading(_ adLoader: GADAdLoader) {
        print("Native AdLoader","DidFinishLoading")
        delegate?.didFinishLoadingNativeAds()
    }
    
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
        print("Native AdLoader","error:",error)
        delegate?.didFailToReceiveNativeAdWithError(error)
        let errorCode = GADErrorCode(rawValue: (error as NSError).code)
        switch (errorCode) {
        case .internalError:
            //                    stopPreloading = true;
            print("Native AdLoader","Internal error, an invalid response was received from the ad server.")
            break;
        case .invalidRequest:
            //                    stopPreloading = true;
            print("Native AdLoader","Invalid ad request, possibly an incorrect ad unit ID was given.")
            break;
        case .networkError:
            print("Native AdLoader","The ad request was unsuccessful due to network connectivity.")
            break;
        case .noFill:
            print("Native AdLoader","The ad request was successful, but no ad was returned due to lack of ad inventory.")
            break;
        case .serverError,.osVersionTooLow,.timeout,.mediationDataError,.mediationAdapterError,.mediationInvalidAdSize,.invalidArgument,.receivedInvalidResponse,.mediationNoFill,.adAlreadyUsed,.applicationIdentifierMissing:
            
            break
         default:
            break
        }
    }
}
