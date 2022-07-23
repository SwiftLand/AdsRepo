//
//  InterstitialAdWrapper.swift
//  AdMobManager
//
//  Created by Ali on 9/3/21.
//

import Foundation
import GoogleMobileAds


public protocol InterstitialAdWrapperDelegate:NSObject {
    func interstitialAd(didReady ad:InterstitialAdWrapper)
    func interstitialAd(didOpen ad:InterstitialAdWrapper)
    func interstitialAd(willClose ad:InterstitialAdWrapper)
    func interstitialAd(didClose ad:InterstitialAdWrapper)
    func interstitialAd(onError ad:InterstitialAdWrapper,error:Error?)
    func interstitialAd(didExpire ad:InterstitialAdWrapper)
}
extension InterstitialAdWrapperDelegate {
    public func interstitialAd(didReady ad:InterstitialAdWrapper){}
    public func interstitialAd(didOpen ad:InterstitialAdWrapper){}
    public func interstitialAd(willClose ad:InterstitialAdWrapper){}
    public func interstitialAd(didClose ad:InterstitialAdWrapper){}
    public func interstitialAd(onError ad:InterstitialAdWrapper,error:Error?){}
    public func interstitialAd(didExpire ad:InterstitialAdWrapper){}
}

public class InterstitialAdWrapper:NSObject {
    
    public private(set) var config:RepoConfig
    public private(set) var loadedAd: GADInterstitialAd?
    public private(set) var loadedDate:TimeInterval? = nil
    public private(set) var isLoading:Bool = false
    public private(set) var showCount:Int = 0
    public var isLoaded:Bool {loadedDate != nil}
    public private(set) weak var owner:InterstitialAdsController? = nil
    public  weak var delegate:InterstitialAdWrapperDelegate?
    
    private weak var timer:Timer? = nil

    init(owner:InterstitialAdsController) {
        self.owner = owner
        self.config = owner.config
    }
    
    func loadAd(){
        guard !isLoading else {return}
        let request = GADRequest()
        isLoading = true
        GADInterstitialAd.load(withAdUnitID:config.adUnitId,
                               request: request,completionHandler: {[weak self] (ad, error) in
                                guard let self = self else{return}
                                self.isLoading = false
                                if let error = error {
                                    print("Interstitial Ad failed to load with error: \(error.localizedDescription)")
                                    self.delegate?.interstitialAd(onError: self, error: error)
                                    self.owner?.interstitialAd(onError:self,error:error)
                                    return
                                }
                                self.loadedAd = ad
                                self.loadedDate = Date().timeIntervalSince1970
                                self.loadedAd?.fullScreenContentDelegate = self
                                self.delegate?.interstitialAd(didReady: self)
                                self.owner?.interstitialAd(didReady: self)
                                self.startExpireInterval()
                               })
    }
    private func startExpireInterval(){
        timer = Timer.scheduledTimer(withTimeInterval: self.config.expireIntervalTime*1000,
                                          repeats: false,
                                          block: {[weak self] timer in
            print("Interstitial Ad was expire")
            guard let self = self else {return}
            self.owner?.interstitialAd(didExpire: self)
            self.delegate?.interstitialAd(didExpire: self)
        })
    }
    func presentAd(vc:UIViewController){
        
        if isReady(vc: vc)  {
            loadedAd?.fullScreenContentDelegate = self
            loadedAd?.present(fromRootViewController: vc)
        } else {
            print("Interstitial Ad  wasn't ready")
        }
    }
    
    func isReady(vc:UIViewController)->Bool{
        guard loadedAd != nil else{return false}
        do{
            try self.loadedAd?.canPresent(fromRootViewController: vc)
            return true
        }catch{
            return false
        }
    }
    private func stopTime(){
        timer?.invalidate()
        timer = nil
    }
    deinit {
        stopTime()
        print("deinit","Interstitial AdWrapper")
    }
}

extension InterstitialAdWrapper{
    static func == (lhs: InterstitialAdWrapper, rhs: InterstitialAdWrapper) -> Bool{
        lhs.loadedAd == rhs.loadedAd
    }
}
extension InterstitialAdWrapper:GADFullScreenContentDelegate{
    public func adDidPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Interstitial Ad  presented.")
        showCount += 1
        delegate?.interstitialAd(didOpen: self)
    }
    /// Tells the delegate that the rewarded ad was dismissed.
    public func adWillDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Interstitial Ad  will dismiss.")
        delegate?.interstitialAd(willClose: self)
    }
    public func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Interstitial Ad did dismissed.")
        delegate?.interstitialAd(didClose: self)
        owner?.interstitialAd(didClose: self)
    }
    /// Tells the delegate that the rewarded ad failed to present.
    public func ad(_ ad: GADFullScreenPresentingAd,
                   didFailToPresentFullScreenContentWithError error: Error) {
        print("Interstitial Ad  failed to present with error: \(error.localizedDescription).")
        delegate?.interstitialAd(onError: self,error:error)
        owner?.interstitialAd(onError: self,error:error)
    }
    
}
