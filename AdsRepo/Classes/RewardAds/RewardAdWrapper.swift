//
//  RewardAdWrapper.swift
//  WidgetBox
//
//  Created by Ali on 9/2/21.
//

import Foundation
import GoogleMobileAds
import UIKit


protocol RewardAdDelegate {
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
    private(set) public var repoConfig:RepoConfig
    private var delegate:RewardAdDelegate? = nil
    private var timer:Timer? = nil
    init(repoConfig:RepoConfig,delegate:RewardAdDelegate? = nil) {
        self.delegate = delegate
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
                                self.delegate?.rewardAd(onError:self,error:error)
                                return
                            }
                            self.loadedAd = ad
                            self.loadedDate = Date().timeIntervalSince1970 * 1000
                            self.loadedAd?.fullScreenContentDelegate = self
                            self.delegate?.rewardAd(didReady: self)
                            self.timer = Timer(fireAt: Date().addingTimeInterval(self.repoConfig.expireIntervalTime), interval: 0, target: self, selector: #selector(self.makeAdExpire), userInfo: nil, repeats: false)
                           })
    }
    
    @objc func makeAdExpire() {
        print("Reward Ad was expire")
        delegate?.rewardAd(didExpire: self)
    }
    
    func presentAd(vc:UIViewController){
        
        if adsIsReady(vc: vc)  {
            loadedAd?.fullScreenContentDelegate = self
            loadedAd?.present(fromRootViewController: vc,
                               userDidEarnRewardHandler: {self.onReceivedReward()})
        } else {
            print("Reward Ad wasn't ready")
        }
    }
    
    func adsIsReady(vc:UIViewController)->Bool{
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
        delegate?.rewardAd(didReward: self, reward: Double(truncating: amount))
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
        delegate?.rewardAd(didOpen: self)
    }
    /// Tells the delegate that the rewarded ad was dismissed.
    public func adWillDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Rewarded ad will dismiss.")
    }
    public func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Rewarded ad dismissed.")
        delegate?.rewardAd(didClose: self)
    }
    /// Tells the delegate that the rewarded ad failed to present.
    public func ad(_ ad: GADFullScreenPresentingAd,
                     didFailToPresentFullScreenContentWithError error: Error) {
        print("Rewarded ad failed to present with error: \(error.localizedDescription).")
        delegate?.rewardAd(onError: self,error:error)
    }
    
}
