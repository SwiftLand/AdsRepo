//
//  RewardAdWrapper.swift
//  WidgetBox
//
//  Created by Ali on 9/2/21.
//

import Foundation
import GoogleMobileAds
import UIKit



public class RewardAdWrapper:NSObject{
    
    private(set) public var loadedAd: GADRewardedAd?
    private(set) public var loadedDate:TimeInterval? = nil
    private(set) public var isLoading:Bool = false
    private(set) public var showCount:Int = 0
    private(set) public var isRewardRecived:Bool = false
    private(set) public var repoConfig:RepoConfig
    private weak var owner:RewardAdsController? = nil
    private var timer:Timer? = nil
    init(repoConfig:RepoConfig,owner:RewardAdsController? = nil) {
        self.owner = owner
        self.repoConfig = repoConfig
    }
    
    func loadAd(){
        guard !isLoading else {return}
        let request = GADRequest()
        isLoading = true
        GADRewardedAd.load(withAdUnitID:repoConfig.adUnitId,
                           request: request,completionHandler: {[weak self] (ad, error) in
                            guard let self = self else{return}
                            self.isLoading = false
                            if let error = error {
                                print("Rewarded ad failed to load with error: \(error.localizedDescription)")
                                self.owner?.rewardAd(onError:self,error:error)
                                return
                            }
                            self.loadedAd = ad
                            self.loadedDate = Date().timeIntervalSince1970
                            self.loadedAd?.fullScreenContentDelegate = self
                            self.owner?.rewardAd(didReady: self)
                            
                            self.timer = Timer.scheduledTimer(withTimeInterval: self.repoConfig.expireIntervalTime, repeats: false, block: {[weak self]  timer in
                                guard let self = self else {return}
                                print("Reward Ad was expire")
                                self.owner?.rewardAd(didExpire: self)
                            })
                        })
        
    }
    
    
    func presentAd(vc:UIViewController){
        
        if isReady(vc: vc)  {
            loadedAd?.fullScreenContentDelegate = self
            loadedAd?.present(fromRootViewController: vc,
                              userDidEarnRewardHandler: {self.onReceivedReward()})
        } else {
            print("Reward Ad wasn't ready")
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
        print("Reward received with amount \(amount).")
        isRewardRecived = true
        owner?.rewardAd(didReward: self, reward: Double(truncating: amount))
    }
    private func stopTime(){
        timer?.invalidate()
        timer = nil
    }
    deinit {
        stopTime()
        print("deinit","Reward AdWrapper")
    }
}
extension RewardAdWrapper:GADFullScreenContentDelegate{
    public func adDidPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Rewarded ad presented.")
        showCount += 1
        owner?.rewardAd(didOpen: self)
    }
    /// Tells the delegate that the rewarded ad was dismissed.
    public func adWillDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Rewarded ad will dismiss.")
    }
    public func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Rewarded ad dismissed.")
        owner?.rewardAd(didClose: self)
    }
    /// Tells the delegate that the rewarded ad failed to present.
    public func ad(_ ad: GADFullScreenPresentingAd,
                   didFailToPresentFullScreenContentWithError error: Error) {
        print("Rewarded ad failed to present with error: \(error.localizedDescription).")
        owner?.rewardAd(onError: self,error:error)
    }
    
}
