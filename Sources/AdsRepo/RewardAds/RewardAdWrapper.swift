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
    
    /// get `GADRewardedAd` object that loaded successfully
    private var _loadedAd: GADRewardedAd?
    public var loadedAd:GADRewardedAdWrapper?{
        return _loadedAd as? GADRewardedAdWrapper
    }
    /// Repository configuration. See **RepositoryConfig.swift** for more details.
    public private(set) var config:RepositoryConfig
    
    /// return current state of `RewardedAdWrapper`.  See **AdState.swift** for more detail
    public private(set) var state:AdState = .waiting
    
    /// Show GADRewardedAd load Date (In milisecond). `nil` if GADRewardedAd does not load yet
    public private(set) var loadedDate:TimeInterval? = nil
  
    /// Show how many time this object return as valid ads to user. See **`loadAd`** function in **InterstitialAdRepository.swift** for more details
    public internal(set) var showCount:Int = 0
    
    /// Return `true` if current ad Wrapper is presenting full-screen otherwise return `false`
    public var isPresenting:Bool{listener.isPresenting}
    
    /// return `true` if the reward is successfully Received otherwise return `false`
    public private(set) var isRewardReceived:Bool = false

    /// Keep a weak reference of the current object owner. an `owner` is a repository object that will interact with this object.
    public private(set) weak var owner:RewardedAdRepositoryProtocol? = nil
    
    /// Keep a weak reference of `RewardedAdWrapperDelegate`. See **InterstitialAdWrapperDelegate.swift** for more details
    public weak var delegate:RewardedAdWrapperDelegate?
    
    /// Protocol to communicate `InterstitialAdWrapper` with its own repository
    internal weak var ownerDelegate:RewardedAdOwnerDelegate? = nil
    internal var adLoader = GADRewardedAd.self//<-- Use in testing
    
    //Keep the `now` object as a variable to make the unit test easy to change the current time
    internal var now:TimeInterval = {Date().timeIntervalSince1970}()
    
    //Interval timer to expire date that's declared in repository config
    private var timer: DispatchSourceTimer? = nil
    
    private lazy var listener = {
        RewardAdWrapperListener(owner: self)
    }()
    
    init(owner:RewardedAdRepositoryProtocol,
                  adOwnerDelegate:RewardedAdOwnerDelegate,
                  config:RepositoryConfig) {
        
        self.owner = owner
        self.ownerDelegate = adOwnerDelegate
        self.config = config
        super.init()
    }
    
   convenience init(owner:RewardedAdRepository) {
       self.init(owner: owner, adOwnerDelegate: owner, config: owner.config)
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
        
        if canPresent(vc: vc)  {
            _loadedAd?.fullScreenContentDelegate = listener
            _loadedAd?.present(fromRootViewController: vc,
                              userDidEarnRewardHandler: {self.onReceivedReward()})
        } else {
            print("Rewarded Ad wasn't ready")
        }
    }
    /// Returns whether the interstitial ad can be presented from the provided root view controller. Sets the error out parameter if the ad can't be presented. Must be called on the main thread.
    /// - Parameter vc: A view controller to present the ad.
    /// - Returns: Return `true` if can present full-screen ad at input UIViewController otherwise return `false`
   public func canPresent(vc:UIViewController)->Bool{
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
