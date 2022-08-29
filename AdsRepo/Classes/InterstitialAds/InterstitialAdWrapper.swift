//
//  InterstitialAdWrapper.swift
//  AdRepo
//
//  Created by Ali on 9/3/21.
//

import Foundation
import GoogleMobileAds

internal protocol InterstitialAdOwnerDelegate:NSObject{
    func adWrapper(didReady ad:InterstitialAdWrapper)
    func adWrapper(didClose ad:InterstitialAdWrapper)
    func adWrapper(onError ad:InterstitialAdWrapper, error: Error?)
    func adWrapper(didExpire ad: InterstitialAdWrapper)
}

public protocol InterstitialAdWrapperDelegate:NSObject {
    func interstitialAdWrapper(didReady ad:InterstitialAdWrapper)
    func interstitialAdWrapper(didOpen ad:InterstitialAdWrapper)
    func interstitialAdWrapper(didRecordClick ad:InterstitialAdWrapper)
    func interstitialAdWrapper(didRecordImpression ad:InterstitialAdWrapper)
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
    public func interstitialAdWrapper(didRecordClick ad:InterstitialAdWrapper){}
    public func interstitialAdWrapper(didRecordImpression ad:InterstitialAdWrapper){}
    public func interstitialAdWrapper(willClose ad:InterstitialAdWrapper){}
    public func interstitialAdWrapper(didClose ad:InterstitialAdWrapper){}
    public func interstitialAdWrapper(didShowCountChanged ad:InterstitialAdWrapper){}
    public func interstitialAdWrapper(didRemoveFromRepository ad:InterstitialAdWrapper){}
    public func interstitialAdWrapper(onError ad:InterstitialAdWrapper,error:Error?){}
    public func interstitialAdWrapper(didExpire ad:InterstitialAdWrapper){}
}

public class GADInterstitialAdWrapper:GADInterstitialAd{
  
    internal weak var _fullScreenContentDelegate:GADFullScreenContentDelegate?
    
    public override var fullScreenContentDelegate: GADFullScreenContentDelegate?{
        get { return _fullScreenContentDelegate }
        set{ _fullScreenContentDelegate = newValue }
    }
}

public class InterstitialAdWrapper:NSObject {
    
    private var _loadedAd: GADInterstitialAd?
    public var loadedAd:GADInterstitialAdWrapper?{
        return _loadedAd as? GADInterstitialAdWrapper
    }
    
    public private(set) var state:AdState = .waiting
    public private(set) var config:RepositoryConfig
    public internal(set) var loadedDate:TimeInterval? = nil
    public internal(set) var showCount:Int = 0
    public var isPresenting:Bool{listener.isPresenting}
    public private(set) weak var owner:InterstitialAdRepository? = nil
    public  weak var delegate:InterstitialAdWrapperDelegate?
    
    internal weak var ownerDelegate:InterstitialAdOwnerDelegate? = nil
    internal var adLoader = GADInterstitialAd.self //<-- Use in testing
    internal var now:TimeInterval = {Date().timeIntervalSince1970}()
    
    private var timer: DispatchSourceTimer? = nil
    
    private lazy var listener:InterstitialAdWrapperListener = {
        InterstitialAdWrapperListener(owner: self)
    }()
    
    init(owner:InterstitialAdRepository) {
        self.owner = owner
        self.ownerDelegate = owner
        self.config = owner.config
    }
    
    func loadAd(){
        guard state == .waiting else {return}
        state = .loading
        let request = GADRequest()
        adLoader.load(withAdUnitID:config.adUnitId,
                      request: request,completionHandler: {[weak self] (ad, error) in
            guard let self = self else{return}
         
            if let error = error {
                print("Interstitial Ad failed to load with error: \(error.localizedDescription)")
                self.state = .error
                self.delegate?.interstitialAdWrapper(onError: self, error: error)
                self.ownerDelegate?.adWrapper(onError:self,error:error)
                return
            }
            self._loadedAd = ad
            self.loadedDate = Date().timeIntervalSince1970
            self.initialExpireTimer()
            self.timer?.resume()
            self.state = .loaded
            self.delegate?.interstitialAdWrapper(didReady: self)
            self.ownerDelegate?.adWrapper(didReady: self)
        })
    }
    
    func initialExpireTimer() {
        timer = DispatchSource.makeTimerSource(queue:DispatchQueue.main)
        timer?.schedule(deadline: .now() +  config.expireIntervalTime)
        timer?.setEventHandler(handler: { [weak self] in
            print("Interstitial Ad was expire")
            guard let self = self else {return}
            self.delegate?.interstitialAdWrapper(didExpire: self)
            self.ownerDelegate?.adWrapper(didExpire: self)
        })
    }
    
    func increaseShowCount(){
        showCount += 1
        delegate?.interstitialAdWrapper(didShowCountChanged: self)
    }
    
    func presentAd(vc:UIViewController){
        
        if isReady(vc: vc)  {
            _loadedAd?.fullScreenContentDelegate = listener
            _loadedAd?.present(fromRootViewController: vc)
        } else {
            print("Interstitial Ad  wasn't ready")
        }
    }
    
    func isReady(vc:UIViewController)->Bool{
        guard _loadedAd != nil else{return false}
        do{
            try self._loadedAd?.canPresent(fromRootViewController: vc)
            return true
        }catch{
            return false
        }
    }
    
    deinit {
        timer?.cancel()
        print("deinit","Interstitial AdWrapper")
    }
}

private class InterstitialAdWrapperListener:NSObject,GADFullScreenContentDelegate{
    weak var owner:InterstitialAdWrapper?
    private(set) var isPresenting:Bool = false
    init(owner:InterstitialAdWrapper) {
        self.owner = owner
    }
    func adDidRecordClick(_ ad: GADFullScreenPresentingAd) {
        guard let owner = owner else {return}
        owner.loadedAd?._fullScreenContentDelegate?.adDidRecordClick?(ad)
        owner.delegate?.interstitialAdWrapper(didRecordClick: owner)
    }
    func adDidRecordImpression(_ ad: GADFullScreenPresentingAd) {
        guard let owner = owner else {return}
        owner.loadedAd?._fullScreenContentDelegate?.adDidRecordImpression?(ad)
        owner.delegate?.interstitialAdWrapper(didRecordImpression: owner)
    }
    func adDidPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Interstitial Ad  presented.")
        isPresenting = true
        guard let owner = owner else {return}
        owner.loadedAd?._fullScreenContentDelegate?.adDidPresentFullScreenContent?(ad)
        owner.delegate?.interstitialAdWrapper(didOpen:  owner)
    }
    /// Tells the delegate that the rewarded ad was dismissed.
    func adWillDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Interstitial Ad  will dismiss.")
        isPresenting = true
        guard let owner = owner else {return}
        owner.loadedAd?._fullScreenContentDelegate?.adWillDismissFullScreenContent?(ad)
        owner.delegate?.interstitialAdWrapper(willClose: owner)
    }
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Interstitial Ad did dismissed.")
        isPresenting = false
        guard let owner = owner else {return}
        owner.loadedAd?._fullScreenContentDelegate?.adDidDismissFullScreenContent?(ad)
        owner.delegate?.interstitialAdWrapper(didClose: owner)
        owner.ownerDelegate?.adWrapper(didClose: owner)
    }
    /// Tells the delegate that the rewarded ad failed to present.
    func ad(_ ad: GADFullScreenPresentingAd,
            didFailToPresentFullScreenContentWithError error: Error) {
        print("Interstitial Ad  failed to present with error: \(error.localizedDescription).")
        isPresenting = false
        guard let owner = owner else {return}
        owner.loadedAd?._fullScreenContentDelegate?.ad?(ad,didFailToPresentFullScreenContentWithError: error)
        owner.delegate?.interstitialAdWrapper(onError: owner,error:error)
    }
}
