//
//  RewardAdWrapper.swift
//  WidgetBox
//
//  Created by Ali on 9/2/21.
//

import Foundation
import GoogleMobileAds
import UIKit

public protocol RewardAdWrapperDelegate:NSObject {
    func rewardAd(didReady ad:RewardAdWrapper)
    func rewardAd(didOpen ad:RewardAdWrapper)
    func rewardAd(willClose ad:RewardAdWrapper)
    func rewardAd(didClose ad:RewardAdWrapper)
    func rewardAd(onError ad:RewardAdWrapper,error:Error?)
    func rewardAd(didReward ad:RewardAdWrapper,reward:Double)
    func rewardAd(didExpire ad:RewardAdWrapper)
}

public class RewardAdWrapper:NSObject{
    
    private(set) public var loadedAd: GADRewardedAd?
    private(set) public var loadedDate:TimeInterval? = nil
    private(set) public var isLoading:Bool = false
    private(set) public var showCount:Int = 0
    private(set) public var isRewardRecived:Bool = false
    private(set) public var config:RepoConfig
    
    public var isLoaded:Bool {loadedDate != nil}
    public weak var delegate:RewardAdWrapperDelegate?
    
    private(set) weak var owner:RewardedAdsController? = nil
    private weak var timer:Timer? = nil
    
    init(owner:RewardedAdsController) {
        self.owner = owner
        self.config = owner.config
    }
    
    func loadAd(){
        guard !isLoading else {return}
        let request = GADRequest()
        isLoading = true
        GADRewardedAd.load(withAdUnitID:config.adUnitId,
                           request: request,completionHandler: {[weak self] (ad, error) in
                            guard let self = self else{return}
                            self.isLoading = false
                            if let error = error {
                                print("Rewarded ad failed to load with error: \(error.localizedDescription)")
                                self.delegate?.rewardAd(onError:self,error:error)
                                self.owner?.rewardAd(onError:self,error:error)
                                return
                            }
                            self.loadedAd = ad
                            self.loadedDate = Date().timeIntervalSince1970
                            self.loadedAd?.fullScreenContentDelegate = self
                            self.delegate?.rewardAd(didReady: self)
                            self.owner?.rewardAd(didReady: self)
                            self.startExpireInterval()
                        })
        
    }
    
   private func startExpireInterval(){
        timer = Timer.scheduledTimer(withTimeInterval: self.config.expireIntervalTime*1000,
                                     repeats: false,
                                     block: {[weak self]  timer in
            guard let self = self else {return}
            print("Rewarded Ad was expire")
            self.delegate?.rewardAd(didExpire: self)
            self.owner?.rewardAd(didExpire: self)
        })
    }
    func presentAd(vc:UIViewController){
        
        if isReady(vc: vc)  {
            loadedAd?.fullScreenContentDelegate = self
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
        isRewardRecived = true
        delegate?.rewardAd(didReward: self, reward: Double(truncating: amount))
    }
    private func stopTime(){
        timer?.invalidate()
        timer = nil
    }
    deinit {
        stopTime()
        print("deinit","Rewarded AdWrapper")
    }
}
extension RewardAdWrapper:GADFullScreenContentDelegate{
    public func adDidPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Rewarded ad presented.")
        showCount += 1
        delegate?.rewardAd(didOpen: self)
    }
    /// Tells the delegate that the rewarded ad was dismissed.
    public func adWillDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Rewarded ad will dismiss.")
        delegate?.rewardAd(willClose: self)
    }
    public func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Rewarded ad dismissed.")
        owner?.rewardAd(didClose: self)
        delegate?.rewardAd(didClose: self)
    }
    /// Tells the delegate that the rewarded ad failed to present.
    public func ad(_ ad: GADFullScreenPresentingAd,
                   didFailToPresentFullScreenContentWithError error: Error) {
        print("Rewarded ad failed to present with error: \(error.localizedDescription).")
        owner?.rewardAd(onError: self,error:error)
        delegate?.rewardAd(onError: self,error:error)
    }
    
}
