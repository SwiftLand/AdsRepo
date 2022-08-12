//
//  InterstitialAdWrapper.swift
//  AdRepo
//
//  Created by Ali on 9/3/21.
//

import Foundation
import GoogleMobileAds


public protocol InterstitialAdWrapperDelegate:NSObject {
    func interstitialAdWrapper(didReady ad:InterstitialAdWrapper)
    func interstitialAdWrapper(didOpen ad:InterstitialAdWrapper)
    func interstitialAdWrapper(willClose ad:InterstitialAdWrapper)
    func interstitialAdWrapper(didClose ad:InterstitialAdWrapper)
    func interstitialAdWrapper(didShowCountChanged ad:InterstitialAdWrapper)
    func interstitialAdWrapper(didRemoveFromRepository ad:InterstitialAdWrapper)
    func interstitialAdWrapper(onError ad:InterstitialAdWrapper,error:Error?)
    func interstitialAdWrapper(didExpire ad:InterstitialAdWrapper)
}
extension InterstitialAdWrapperDelegate {
    public func interstitialAdWrapper(didReady ad:InterstitialAdWrapper){}
    public func interstitialAdWrapper(didOpen ad:InterstitialAdWrapper){}
    public func interstitialAdWrapper(willClose ad:InterstitialAdWrapper){}
    public func interstitialAdWrapper(didClose ad:InterstitialAdWrapper){}
    public func interstitialAdWrapper(didShowCountChanged ad:InterstitialAdWrapper){}
    public func interstitialAdWrapper(didRemoveFromRepository ad:InterstitialAdWrapper){}
    public func interstitialAdWrapper(onError ad:InterstitialAdWrapper,error:Error?){}
    public func interstitialAdWrapper(didExpire ad:InterstitialAdWrapper){}
}

public class InterstitialAdWrapper:NSObject {
    
    var loadedAd: GADInterstitialAd?
    public private(set) var config:RepositoryConfig
    public internal(set) var loadedDate:TimeInterval? = nil
    public internal(set) var showCount:Int = 0
    public private(set) var isLoading:Bool = false
    public var isPresenting:Bool{listener.isPresenting}
    public var isLoaded:Bool {loadedDate != nil}
    public private(set) weak var owner:InterstitialAdRepository? = nil
    public  weak var delegate:InterstitialAdWrapperDelegate?
    
    internal var adLoader = GADInterstitialAd.self //<-- Use in testing
    internal var now:TimeInterval = {Date().timeIntervalSince1970}()
    
    private lazy var timer: DispatchSourceTimer = {
        let t = DispatchSource.makeTimerSource(queue:DispatchQueue.main)
        t.schedule(deadline: .now() +  config.expireIntervalTime)
        t.setEventHandler(handler: { [weak self] in
            print("Interstitial Ad was expire")
            guard let self = self else {return}
            self.owner?.interstitialAdWrapper(didExpire: self)
            self.delegate?.interstitialAdWrapper(didExpire: self)
        })
        return t
    }()
    
    private lazy var listener:InterstitialAdWrapperListener = {
        InterstitialAdWrapperListener(owner: self)
    }()
    
    public var responseInfo: GADResponseInfo? {
        get{
           return self.loadedAd?.responseInfo
        }
    }
    var paidEventHandler: GADPaidEventHandler? {
        get{self.loadedAd?.paidEventHandler}
        set{self.loadedAd?.paidEventHandler = newValue}
    }
    
    init(owner:InterstitialAdRepository) {
        self.owner = owner
        self.config = owner.config
    }
    
    func loadAd(){
        guard !isLoading else {return}
        isLoading = true
        let request = GADRequest()
        adLoader.load(withAdUnitID:config.adUnitId,
                               request: request,completionHandler: {[weak self] (ad, error) in
            guard let self = self else{return}
            self.isLoading = false
            if let error = error {
                print("Interstitial Ad failed to load with error: \(error.localizedDescription)")
                self.delegate?.interstitialAdWrapper(onError: self, error: error)
                self.owner?.interstitialAdWrapper(onError:self,error:error)
                return
            }
            self.loadedAd = ad
            self.loadedDate = Date().timeIntervalSince1970
            self.delegate?.interstitialAdWrapper(didReady: self)
            self.owner?.interstitialAdWrapper(didReady: self)
            self.timer.resume()
        })
    }
    
    
    func increaseShowCount(){
        showCount += 1
        delegate?.interstitialAdWrapper(didShowCountChanged: self)
    }
    
    func presentAd(vc:UIViewController){
        
        if isReady(vc: vc)  {
            loadedAd?.fullScreenContentDelegate = listener
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
    
    deinit {
        if isLoaded {
            timer.cancel()
        }
        print("deinit","Interstitial AdWrapper")
    }
}

private class InterstitialAdWrapperListener:NSObject,GADFullScreenContentDelegate{
    weak var owner:InterstitialAdWrapper?
    private(set) var isPresenting:Bool = false
    init(owner:InterstitialAdWrapper) {
        self.owner = owner
    }
    func adDidPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Interstitial Ad  presented.")
        isPresenting = true
        guard let owner = owner else {return}
        owner.delegate?.interstitialAdWrapper(didOpen:  owner)
    }
    /// Tells the delegate that the rewarded ad was dismissed.
    func adWillDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Interstitial Ad  will dismiss.")
        isPresenting = true
        guard let owner = owner else {return}
        owner.delegate?.interstitialAdWrapper(willClose: owner)
    }
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Interstitial Ad did dismissed.")
        isPresenting = false
        guard let owner = owner else {return}
        owner.delegate?.interstitialAdWrapper(didClose: owner)
        owner.owner?.interstitialAdWrapper(didClose: owner)
    }
    /// Tells the delegate that the rewarded ad failed to present.
    func ad(_ ad: GADFullScreenPresentingAd,
            didFailToPresentFullScreenContentWithError error: Error) {
        print("Interstitial Ad  failed to present with error: \(error.localizedDescription).")
        isPresenting = false
        guard let owner = owner else {return}
        owner.delegate?.interstitialAdWrapper(onError: owner,error:error)
        owner.owner?.interstitialAdWrapper(onError: owner,error:error)
    }
}
