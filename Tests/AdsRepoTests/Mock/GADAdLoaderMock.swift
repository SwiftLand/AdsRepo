//
//  GADAdLoaderMock.swift
//  AdsRepo-Unit-Tests
//
//  Created by Ali on 8/10/22.
//

// Generated using Sourcery 1.8.2 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
// swiftlint:disable line_length
// swiftlint:disable variable_name

import Foundation
import GoogleMobileAds
#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif
















class GADAdLoaderMock: GADAdLoader {
    override var delegate: GADAdLoaderDelegate?{
        get { return underlyingDelegate }
        set(value) { underlyingDelegate = value as? any GADNativeAdLoaderDelegate }
    }
    var underlyingDelegate: GADNativeAdLoaderDelegate?
    
    override var adUnitID: String {
        get { return underlyingAdUnitID }
        set(value) { underlyingAdUnitID = value }
    }
    var underlyingAdUnitID: String!
    
    override var isLoading: Bool {
        get { return underlyingLoading }
        set(value) { underlyingLoading = value }
    }
    var underlyingLoading: Bool!

    //MARK: - init

    var initAdUnitIDRootViewControllerAdTypesOptionsReceivedArguments: (adUnitID: String, rootViewController: UIViewController?, adTypes: [GADAdLoaderAdType], options: [GADAdLoaderOptions]?)?
    var initAdUnitIDRootViewControllerAdTypesOptionsReceivedInvocations: [(adUnitID: String, rootViewController: UIViewController?, adTypes: [GADAdLoaderAdType], options: [GADAdLoaderOptions]?)] = []
    var initAdUnitIDRootViewControllerAdTypesOptionsClosure: ((String, UIViewController?, [GADAdLoaderAdType], [GADAdLoaderOptions]?) -> Void)?

    override init(adUnitID: String, rootViewController: UIViewController?, adTypes: [GADAdLoaderAdType], options: [GADAdLoaderOptions]?) {
        initAdUnitIDRootViewControllerAdTypesOptionsReceivedArguments = (adUnitID: adUnitID, rootViewController: rootViewController, adTypes: adTypes, options: options)
        initAdUnitIDRootViewControllerAdTypesOptionsReceivedInvocations.append((adUnitID: adUnitID, rootViewController: rootViewController, adTypes: adTypes, options: options))
        initAdUnitIDRootViewControllerAdTypesOptionsClosure?(adUnitID, rootViewController, adTypes, options)
        super.init(adUnitID: adUnitID, rootViewController: rootViewController, adTypes: adTypes, options: options)
    }
    //MARK: - load

    var loadCallsCount = 0
    var loadCalled: Bool {
        return loadCallsCount > 0
    }
    var loadReceivedRequest: GADRequest?
    var loadReceivedInvocations: [GADRequest?] = []
    var loadClosure: ((GADRequest?) -> Void)?

    override func load(_ request: GADRequest?) {
        loadCallsCount += 1
        loadReceivedRequest = request
        loadReceivedInvocations.append(request)
        loadClosure?(request)
        MockLoadProcess()
    }
    
    //MARK: - load
    static var error:NSError? = nil
    func MockLoadProcess() {
        guard GADAdLoaderMock.error == nil else{
            underlyingDelegate?.adLoader(self, didFailToReceiveAdWithError: GADAdLoaderMock.error!)
            return
        }
      
        
        let options = initAdUnitIDRootViewControllerAdTypesOptionsReceivedArguments?.options
        
        if let multiAdOption =  options?.first(where:{$0 is GADMultipleAdsAdLoaderOptions}) as? GADMultipleAdsAdLoaderOptions{
            
            for _ in 0..<multiAdOption.numberOfAds{
                let ad = GADNativeAdMock()
                underlyingDelegate?.adLoader(self, didReceive: ad)
            }
        }else{
            let ad = GADNativeAdMock()
            underlyingDelegate?.adLoader(self, didReceive: ad)
        }
        
        
        underlyingDelegate?.adLoaderDidFinishLoading?(self)
    }
}
