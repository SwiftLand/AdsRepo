//
//  RewardAdWrapper.swift
//  AdRepo
//
//  Created by Ali on 9/2/21.
//

import Foundation
import GoogleMobileAds
import UIKit

public protocol RewardedAdWrapperDelegate:NSObject {
    func rewardedAdWrapper(didReady ad:RewardedAdWrapper)
    func rewardedAdWrapper(didOpen ad:RewardedAdWrapper)
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
    public func rewardedAdWrapper(willClose ad:RewardedAdWrapper){}
    public func rewardedAdWrapper(didClose ad:RewardedAdWrapper){}
    public func rewardedAdWrapper(didShowCountChanged ad:RewardedAdWrapper){}
    public func rewardedAdWrapper(didRemoveFromRepository ad:RewardedAdWrapper){}
    public func rewardedAdWrapper(onError ad:RewardedAdWrapper,error:Error?){}
    public func rewardedAdWrapper(didReward ad:RewardedAdWrapper,reward:Double){}
    public func rewardedAdWrapper(didExpire ad:RewardedAdWrapper){}
}


public class RewardedAdWrapper:NSObject{
    
    var loadedAd: GADRewardedAd?
    public private(set) var state:AdState = .waiting
    public private(set) var loadedDate:TimeInterval? = nil
    public var isPresenting:Bool{listener.isPresenting}
    public internal(set) var showCount:Int = 0
    public private(set) var isRewardReceived:Bool = false
    public private(set) var config:RepositoryConfig
    public private(set) weak var owner:RewardedAdRepository? = nil
    public weak var delegate:RewardedAdWrapperDelegate?
    
    internal var adLoader = GADRewardedAd.self//<-- Use in testing
    internal var now:TimeInterval = {Date().timeIntervalSince1970}()
    
    private var timer: DispatchSourceTimer? = nil
    
    private lazy var listener = {
        RewardAdWrapperListener(owner: self)
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
    
    init(owner:RewardedAdRepository) {
        self.owner = owner
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
                self.owner?.rewardedAdWrapper(onError:self,error:error)
                return
            }
            self.loadedAd = ad
            self.loadedDate = Date().timeIntervalSince1970
            self.loadedAd?.fullScreenContentDelegate = self.listener
            self.initialExpireTimer()
            self.timer?.resume()
            self.state = .loaded
            self.delegate?.rewardedAdWrapper(didReady: self)
            self.owner?.rewardedAdWrapper(didReady: self)
         
        })
        
    }
    
    func initialExpireTimer() {
        timer = DispatchSource.makeTimerSource(queue:DispatchQueue.main)
        timer?.schedule(deadline: .now() +  config.expireIntervalTime)
        timer?.setEventHandler(handler: { [weak self] in
            print("Interstitial Ad was expire")
            guard let self = self else {return}
            self.owner?.rewardedAdWrapper(didExpire: self)
            self.delegate?.rewardedAdWrapper(didExpire: self)
        })
    }
    
    func increaseShowCount(){
        showCount += 1
        delegate?.rewardedAdWrapper(didShowCountChanged: self)
    }
    
    func presentAd(vc:UIViewController){
        
        if isReady(vc: vc)  {
            loadedAd?.fullScreenContentDelegate = listener
            loadedAd?.present(fromRootViewController: vc,
                              userDidEarnRewardHandler: {self.onReceivedReward()})
        } else {
            print("Rewarded Ad wasn't ready")
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
    
    private func onReceivedReward (){
        guard let rewardedAd = loadedAd ,rewardedAd.adReward.amount != 0 else {
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
    func adDidPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Rewarded ad presented.")
        isPresenting = true
        guard let owner = owner else {return}
        owner.delegate?.rewardedAdWrapper(didOpen: owner)
    }
    /// Tells the delegate that the rewarded ad was dismissed.
    func adWillDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Rewarded ad will dismiss.")
        isPresenting = true
        guard let owner = owner else {return}
        owner.delegate?.rewardedAdWrapper(willClose: owner)
    }
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Rewarded ad dismissed.")
        isPresenting = false
        guard let owner = owner else {return}
        owner.owner?.rewardedAdWrapper(didClose: owner)
        owner.delegate?.rewardedAdWrapper(didClose: owner)
    }
    /// Tells the delegate that the rewarded ad failed to present.
    func ad(_ ad: GADFullScreenPresentingAd,
                   didFailToPresentFullScreenContentWithError error: Error) {
        print("Rewarded ad failed to present with error: \(error.localizedDescription).")
        isPresenting = false
        guard let owner = owner else {return}
        owner.owner?.rewardedAdWrapper(onError: owner,error:error)
        owner.delegate?.rewardedAdWrapper(onError: owner,error:error)
    }
}
