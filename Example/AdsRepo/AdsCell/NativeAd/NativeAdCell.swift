//
//  NativeAdCell.swift
//  WidgetBox
//
//  Created by Ali on 9/4/21.
//

import Foundation
import UIKit
import GoogleMobileAds
import AdsRepo

protocol NativeAdCellDelegate{
    
}
class NativeAdCell:UICollectionViewCell{
    
    var observerId: String = UUID().uuidString
    @IBOutlet weak var adView:UIView!
    @IBOutlet weak var nativeAdView: GADNativeAdView!
    @IBOutlet weak var adIconLeadingConstrian: NSLayoutConstraint!
    @IBOutlet weak var adIconWidthConstrians: NSLayoutConstraint!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var showCountLabel:UILabel!
    
    weak var adWrapper:GADNativeAdWrapper? = nil {
        didSet{
            guard let adWrapper = adWrapper else {
                showActivityIndicator()
                return
            }
            showCountLabel.text = "show count (\(adWrapper.showCount))"
            showNativeAd()
            hideActivityIndicator()
        }
    }
    
    func showActivityIndicator(){
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        adView.isHidden = true
    }
    func hideActivityIndicator(){
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        adView.isHidden = false
    }
    
    private func showNativeAd() {
        guard let nativeAd = adWrapper?.loadedAd else {return}


        // Populate the native ad view with the native ad assets.
        // The headline and mediaContent are guaranteed to be present in every native ad.
        (nativeAdView.headlineView as? UILabel)?.text = nativeAd.headline
        nativeAdView.mediaView?.mediaContent = nativeAd.mediaContent

        // This app uses a fixed width for the GADMediaView and changes its height to match the aspect
        // ratio of the media it displays.
        if let mediaView = nativeAdView.mediaView, nativeAd.mediaContent.aspectRatio > 0 {
          let heightConstraint = NSLayoutConstraint(
            item: mediaView,
            attribute: .height,
            relatedBy: .equal,
            toItem: mediaView,
            attribute: .width,
            multiplier: CGFloat(1 / nativeAd.mediaContent.aspectRatio),
            constant: 0)
          heightConstraint.isActive = true
        }

        // These assets are not guaranteed to be present. Check that they are before
        // showing or hiding them.
        (nativeAdView.bodyView as? UILabel)?.text = nativeAd.body
        nativeAdView.bodyView?.isHidden = nativeAd.body == nil

        (nativeAdView.callToActionView as? UIButton)?.setTitle(nativeAd.callToAction, for: .normal)
        nativeAdView.callToActionView?.isHidden = nativeAd.callToAction == nil

        (nativeAdView.iconView as? UIImageView)?.image = nativeAd.icon?.image
        nativeAdView.iconView?.isHidden = nativeAd.icon == nil

        (nativeAdView.starRatingView as? UIImageView)?.image = imageOfStars(
          fromStarRating: nativeAd.starRating)
        nativeAdView.starRatingView?.isHidden = nativeAd.starRating == nil

        (nativeAdView.storeView as? UILabel)?.text = nativeAd.store
        nativeAdView.storeView?.isHidden = nativeAd.store == nil

        (nativeAdView.priceView as? UILabel)?.text = nativeAd.price
        nativeAdView.priceView?.isHidden = nativeAd.price == nil

        (nativeAdView.advertiserView as? UILabel)?.text = nativeAd.advertiser
        nativeAdView.advertiserView?.isHidden = nativeAd.advertiser == nil

        // In order for the SDK to process touch events properly, user interaction should be disabled.
        nativeAdView.callToActionView?.isUserInteractionEnabled = false

        // Associate the native ad view with the native ad object. This is
        // required to make the ad clickable.
        // Note: this should always be done after populating the ad views.
        nativeAdView.nativeAd = nativeAd
    }
    
    func imageOfStars(fromStarRating starRating: NSDecimalNumber?) -> UIImage? {
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

