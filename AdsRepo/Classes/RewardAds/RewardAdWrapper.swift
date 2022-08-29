//
//  RewardAdWrapper.swift
//  AdRepo
//
//  Created by Ali on 9/2/21.
//

import Foundation
import GoogleMobileAds
import UIKit

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
