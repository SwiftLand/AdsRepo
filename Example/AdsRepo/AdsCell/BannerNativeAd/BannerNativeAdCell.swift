//
//  BannerNativeAd.swift
//  NextIcon
//
//  Created by Ali on 10/20/21.
//
import Foundation
import UIKit
import GoogleMobileAds
import AdsRepo

class BannerNativeAdCell:UICollectionViewCell{
    var observerId: String = UUID().uuidString
    var isLoaded:Bool {nativeAdView.nativeAd != nil}
    weak var adController:NativeAdsRepository? = nil
    
    @IBOutlet weak var adView:UIView!
    @IBOutlet weak var adLabel:UILabel!
    @IBOutlet weak var nativeAdView: GADNativeAdView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var showCountLabel:UILabel!
    
    @IBOutlet weak var adIconLeadingConstrian: NSLayoutConstraint!
    @IBOutlet weak var adIconWidthConstrians: NSLayoutConstraint!

    weak var adRepository:NativeAdsRepository? = nil
    weak var adWrapper:NativeAdWrapper? = nil {
        didSet{
            adWrapper?.delegate = self//<-- weak reference
            showCountLabel?.text = "show count (\(adWrapper?.showCount ?? 0))"
        }
    }
    
    func showNativeAdIfNeed(){
        self.adView.isHidden = true
        adRepository?.loadAd {[weak self] adWrapper in
            if let adWrapper = adWrapper {
                self?.adWrapper = adWrapper
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
    func showActivityIndicator(){
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
    }
    func hideActivityIndicator(){
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    
    
    private func showNativeAd(_ nativeAd: GADNativeAd) {
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
        
        if nativeAd.icon != nil{
            adIconLeadingConstrian.constant = 8
            adIconWidthConstrians.constant = 60
        }else{
            adIconLeadingConstrian.constant = 0
            adIconWidthConstrians.constant = 0
        }
        
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
        adView.isHidden = false
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

extension BannerNativeAdCell:AdsRepoObserver{
    func nativeAdsRepository(didReceive repo: NativeAdsRepository) {
        guard !isLoaded else {return}
        showNativeAdIfNeed()
    }
}

extension BannerNativeAdCell:NativeAdWrapperDelegate{
    func nativeAdWrapper(didExpire ad: NativeAdWrapper) {
        guard isLoaded ,ad.loadedAd == nativeAdView.nativeAd else{
            return
        }
        showNativeAdIfNeed()
    }
}
