//
//  FullScreenNativeAd.swift
//  AdsRepo_Example
//
//  Created by Ali on 7/23/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import AdsRepo
import GoogleMobileAds

class FullScreenNativeAdVC: UIViewController {
    
    var isLoaded:Bool {nativeAdView.nativeAd != nil}
    @IBOutlet weak var nativeAdView: GADNativeAdView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    weak var adRepository:NativeAdsRepository? = nil
    
    override func viewWillAppear(_ animated: Bool) {
        nativeAdView.isHidden = true
        if let adController = adRepository {
            showNativeAd(adController)
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        deregisterCellForAdsRepo()
    }
    
    func showActivityIndicator(){
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
    }
    func hideActivityIndicator(){
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    func showNativeAd(_ adController:NativeAdsRepository){
        self.adRepository = adController
        adController.loadAd {[weak self] adWrapper in
            if let adWrapper = adWrapper {
                adWrapper.delegate = self//<-- weak reference
                self?.showNativeAd(adWrapper.loadedAd)
                self?.hideActivityIndicator()
            }else{
                self?.showActivityIndicator()
                self?.registerCellForAdsRepo()
            }
        }
    }

    func registerCellForAdsRepo(){
        AdsRepo.default.addObserver(observer: self)
    }
    func deregisterCellForAdsRepo(){
        AdsRepo.default.removeObserver(observer: self)
    }
    
    private func showNativeAd(_ nativeAd: GADNativeAd) {
       
        // This app uses a fixed width for the GADMediaView and changes its height to match the aspect
        // Set the mediaContent on the GADMediaView to populate it with available
        // video/image asset.
        nativeAdView.mediaView?.mediaContent = nativeAd.mediaContent
        // Populate the native ad view with the native ad assets.
        // The headline is guaranteed to be present in every native ad.
        (nativeAdView.headlineView as? UILabel)?.text = nativeAd.headline
        
        // These assets are not guaranteed to be present. Check that they are before
        // showing or hiding them.
        (nativeAdView.bodyView as? UILabel)?.text = nativeAd.body
        nativeAdView.bodyView?.isHidden = nativeAd.body == nil
        
        (nativeAdView.callToActionView as? UIButton)?.setTitle(nativeAd.callToAction, for: .normal)
        nativeAdView.callToActionView?.isHidden = nativeAd.callToAction == nil
        
        (nativeAdView.iconView as? UIImageView)?.image = nativeAd.icon?.image
        nativeAdView.iconView?.isHidden = nativeAd.icon == nil

        
        (nativeAdView.starRatingView as? UIImageView)?.image = imageOfStars(from: nativeAd.starRating)
        nativeAdView.starRatingView?.isHidden = nativeAd.starRating == nil
        
        (nativeAdView.storeView as? UILabel)?.text = nativeAd.store
        nativeAdView.storeView?.isHidden = nativeAd.store == nil
        
        (nativeAdView.priceView as? UILabel)?.text = nativeAd.price
        nativeAdView.priceView?.isHidden = nativeAd.price == nil
        
        (nativeAdView.advertiserView as? UILabel)?.text = nativeAd.advertiser
        nativeAdView.advertiserView?.isHidden = nativeAd.advertiser == nil
        
        // In order for the SDK to process touch events properly, user interaction
        // should be disabled.
        nativeAdView.callToActionView?.isUserInteractionEnabled = false
        
        // Associate the native ad view with the native ad object. This is
        // required to make the ad clickable.
        // Note: this should always be done after populating the ad views.
        nativeAdView.nativeAd = nativeAd
        nativeAdView.isHidden = false
    }
    
    func imageOfStars(from starRating: NSDecimalNumber?) -> UIImage? {
        guard let rating = starRating?.doubleValue else {
            return nil
        }
        if rating >= 5 {
            return UIImage(named: "stars_5")
        } else if rating >= 4.5 {
            return UIImage(named: "stars_4_5")
        } else if rating >= 4 {
            return UIImage(named: "stars_4")
        } else if rating >= 3.5 {
            return UIImage(named: "stars_3_5")
        } else {
            return nil
        }
    }
}


extension FullScreenNativeAdVC:AdsRepoDelegate{
    func nativeAdsRepository(didReceive repo: NativeAdsRepository) {
        guard !isLoaded,let adController = self.adRepository else {return}
        showNativeAd(adController)
    }
}

extension FullScreenNativeAdVC:NativeAdWrapperDelegate{
    func nativeAdWrapper(didExpire ad: NativeAdWrapper) {
        if isLoaded ,
           ad.loadedAd == nativeAdView.nativeAd,
           let adController = self.adRepository {
            showNativeAd(adController)
        }
    }
}
