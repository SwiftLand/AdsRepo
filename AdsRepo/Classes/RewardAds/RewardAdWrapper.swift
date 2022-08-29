//
//  RewardAdWrapper.swift
//  AdRepo
//
//  Created by Ali on 9/2/21.
//

import Foundation
import GoogleMobileAds
import UIKit

internal protocol RewardedAdOwnerDelegate:NSObject{
    func adWrapper(didReady ad:RewardedAdWrapper)
    func adWrapper(didClose ad:RewardedAdWrapper)
    func adWrapper(onError ad:RewardedAdWrapper, error: Error?)
    func adWrapper(didExpire ad: RewardedAdWrapper)
}
public protocol RewardedAdWrapperDelegate:NSObject {
    func rewardedAdWrapper(didReady ad:RewardedAdWrapper)
    func rewardedAdWrapper(didOpen ad:RewardedAdWrapper)
    func rewardedAdWrapper(didRecordClick ad:RewardedAdWrapper)
    func rewardedAdWrapper(didRecordImpression ad:RewardedAdWrapper)
    func rewardedAdWrapper(willClose ad:RewardedAdWrapper)
    func rewardedAdWrapper(didClose ad:RewardedAdWrapper)
    func rewardedAdWrapper(didShowCountChanged ad:RewardedAdWrapper)
    func rewardedAdWrapper(didRemoveFromRepository ad:RewardedAdWrapper)
    func rewardedAdWrapper(onError ad:RewardedAdWrapper,error:Error?)
    func rewardedAdWrapper(didReward ad:RewardedAdWrapper,reward:Double)
    func rewardedAdWrapper(didExpire ad:RewardedAdWrapper)
}
extension RewardedAdWrapperDelegate {
    public func rewardedAdWrapper(didReady ad:RewardedAdWrapper){}
    public func rewardedAdWrapper(didOpen ad:RewardedAdWrapper){}
    public func rewardedAdWrapper(didRecordClick ad:RewardedAdWrapper){}
    public func rewardedAdWrapper(didRecordImpression ad:RewardedAdWrapper){}
    public func rewardedAdWrapper(willClose ad:RewardedAdWrapper){}
    public func rewardedAdWrapper(didClose ad:RewardedAdWrapper){}
    public func rewardedAdWrapper(didShowCountChanged ad:RewardedAdWrapper){}
    public func rewardedAdWrapper(didRemoveFromRepository ad:RewardedAdWrapper){}
    public func rewardedAdWrapper(onError ad:RewardedAdWrapper,error:Error?){}
    public func rewardedAdWrapper(didReward ad:RewardedAdWrapper,reward:Double){}
    public func rewardedAdWrapper(didExpire ad:RewardedAdWrapper){}
}

public class GADRewardedAdWrapper:GADRewardedAd{
  
    internal weak var _fullScreenContentDelegate:GADFullScreenContentDelegate?
    
    public override var fullScreenContentDelegate: GADFullScreenContentDelegate?{
        get { return _fullScreenContentDelegate }
        set{ _fullScreenContentDelegate = newValue }
    }
}

public class RewardedAdWrapper:NSObject{
    
    private var _loadedAd: GADRewardedAd?
    public var loadedAd:GADRewardedAdWrapper?{
        return _loadedAd as? GADRewardedAdWrapper
    }
    
    public private(set) var state:AdState = .waiting
    public private(set) var loadedDate:TimeInterval? = nil
    public var isPresenting:Bool{listener.isPresenting}
    public internal(set) var showCount:Int = 0
    public private(set) var isRewardReceived:Bool = false
    public private(set) var config:RepositoryConfig
    public private(set) weak var owner:RewardedAdRepository? = nil
    public weak var delegate:RewardedAdWrapperDelegate?
    
    internal weak var ownerDelegate:RewardedAdOwnerDelegate? = nil
    internal var adLoader = GADRewardedAd.self//<-- Use in testing
    internal var now:TimeInterval = {Date().timeIntervalSince1970}()
    
    private var timer: DispatchSourceTimer? = nil
    
    private lazy var listener = {
        RewardAdWrapperListener(owner: self)
    }()
    
   
    init(owner:RewardedAdRepository) {
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
                print("Rewarded ad failed to load with error: \(error.localizedDescription)")
                self.state = .error
                self.delegate?.rewardedAdWrapper(onError:self,error:error)
                self.ownerDelegate?.adWrapper(onError:self,error:error)
                return
            }
            self._loadedAd = ad
            self.loadedDate = Date().timeIntervalSince1970
            self.initialExpireTimer()
            self.timer?.resume()
            self.state = .loaded
            self.delegate?.rewardedAdWrapper(didReady: self)
            self.ownerDelegate?.adWrapper(didReady: self)
         
        })
        
    }
    
    func initialExpireTimer() {
        timer = DispatchSource.makeTimerSource(queue:DispatchQueue.main)
        timer?.schedule(deadline: .now() +  config.expireIntervalTime)
        timer?.setEventHandler(handler: { [weak self] in
            print("Interstitial Ad was expire")
            guard let self = self else {return}
            self.delegate?.rewardedAdWrapper(didExpire: self)
            self.ownerDelegate?.adWrapper(didExpire: self)
        })
    }
    
    func increaseShowCount(){
        showCount += 1
        delegate?.rewardedAdWrapper(didShowCountChanged: self)
    }
    
    func presentAd(vc:UIViewController){
        
        if isReady(vc: vc)  {
            _loadedAd?.fullScreenContentDelegate = listener
            _loadedAd?.present(fromRootViewController: vc,
                              userDidEarnRewardHandler: {self.onReceivedReward()})
        } else {
            print("Rewarded Ad wasn't ready")
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
    
    private func onReceivedReward (){
        guard let rewardedAd = _loadedAd ,rewardedAd.adReward.amount != 0 else {
            return
        }
        let amount = rewardedAd.adReward.amount
        print("Rewarded received with amount \(amount).")
        isRewardReceived = true
        delegate?.rewardedAdWrapper(didReward: self, reward: Double(truncating: amount))
    }
  
    deinit {
        timer?.cancel()
        print("deinit","Rewarded AdWrapper")
    }
}

private class RewardAdWrapperListener:NSObject,GADFullScreenContentDelegate{
    weak var owner:RewardedAdWrapper?
    private(set) var isPresenting:Bool = false
    init(owner:RewardedAdWrapper) {
        self.owner = owner
    }
    func adDidRecordClick(_ ad: GADFullScreenPresentingAd) {
        guard let owner = owner else {return}
        owner.loadedAd?._fullScreenContentDelegate?.adDidRecordClick?(ad)
        owner.delegate?.rewardedAdWrapper(didRecordClick: owner)
    }
    func adDidRecordImpression(_ ad: GADFullScreenPresentingAd) {
        guard let owner = owner else {return}
        owner.loadedAd?._fullScreenContentDelegate?.adDidRecordImpression?(ad)
        owner.delegate?.rewardedAdWrapper(didRecordImpression: owner)
    }
    func adDidPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Rewarded ad presented.")
        isPresenting = true
        guard let owner = owner else {return}
        owner.loadedAd?._fullScreenContentDelegate?.adDidPresentFullScreenContent?(ad)
        owner.delegate?.rewardedAdWrapper(didOpen:  owner)
    }
    /// Tells the delegate that the rewarded ad was dismissed.
    func adWillDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Rewarded ad will dismiss.")
        isPresenting = true
        guard let owner = owner else {return}
        owner.loadedAd?._fullScreenContentDelegate?.adWillDismissFullScreenContent?(ad)
        owner.delegate?.rewardedAdWrapper(willClose: owner)
    }
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Rewarded ad dismissed.")
        isPresenting = false
        guard let owner = owner else {return}
        owner.loadedAd?._fullScreenContentDelegate?.adDidDismissFullScreenContent?(ad)
        owner.delegate?.rewardedAdWrapper(didClose: owner)
        owner.ownerDelegate?.adWrapper(didClose: owner)
    }
    /// Tells the delegate that the rewarded ad failed to present.
    func ad(_ ad: GADFullScreenPresentingAd,
            didFailToPresentFullScreenContentWithError error: Error) {
        print("Rewarded Ad  failed to present with error: \(error.localizedDescription).")
        isPresenting = false
        guard let owner = owner else {return}
        owner.loadedAd?._fullScreenContentDelegate?.ad?(ad,didFailToPresentFullScreenContentWithError: error)
        owner.delegate?.rewardedAdWrapper(onError: owner,error:error)
    }
}
