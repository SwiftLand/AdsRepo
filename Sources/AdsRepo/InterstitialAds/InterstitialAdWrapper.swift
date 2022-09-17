//
//  InterstitialAdWrapper.swift
//  AdRepo
//
//  Created by Ali on 9/3/21.
//

import Foundation
import GoogleMobileAds


public class InterstitialAdWrapper:NSObject {
    
    /// get `GADInterstitialAd` object that loaded successfully
    private var _loadedAd: GADInterstitialAd?
    public var loadedAd:GADInterstitialAdWrapper?{
        return _loadedAd as? GADInterstitialAdWrapper
    }
    
    
    /// return current state of `InterstitialAdWrapper`.  See **AdState.swift** for more detail
    public private(set) var state:AdState = .waiting
    
    /// Repository configuration. See **RepositoryConfig.swift** for more details.
    public private(set) var config:RepositoryConfig
    
    /// Show GADInterstitialAd load Date (In milisecond). `nil` if GADInterstitialAd does not load yet
    public internal(set) var loadedDate:TimeInterval? = nil
    
    /// Show how many time this object return as valid ads to user. See **`loadAd`** function in **InterstitialAdRepository.swift** for more details
    public internal(set) var showCount:Int = 0
    
    /// Return `true` if current ad Wrapper is presenting full-screen otherwise return `false`
    public var isPresenting:Bool{listener.isPresenting}
    
    /// Keep a weak reference of the current object owner. an `owner` is a repository object that will interact with this object.
    public private(set) weak var owner:InterstitialAdRepositoryProtocol? = nil
    
    /// Keep a weak reference of `InterstitialAdWrapperDelegate`. See **InterstitialAdWrapperDelegate.swift** for more details
    public  weak var delegate:InterstitialAdWrapperDelegate?
    
    /// Protocol to communicate `InterstitialAdWrapper` with its own repository
    internal weak var ownerDelegate:InterstitialAdOwnerDelegate? = nil
    
    internal var adLoader = GADInterstitialAd.self //<-- Use in unit test
    
    //Keep the `now` object as a variable to make the unit test easy to change the current time
    internal var now:TimeInterval = {Date().timeIntervalSince1970}()
    
    //Interval timer to expire date that's declared in repository config
    private var timer: DispatchSourceTimer? = nil
    
    private lazy var listener:InterstitialAdWrapperListener = {
        InterstitialAdWrapperListener(owner: self)
    }()
    
    init(owner:InterstitialAdRepositoryProtocol,
                  adOwnerDelegate:InterstitialAdOwnerDelegate,
                  config:RepositoryConfig) {
        
        self.owner = owner
        self.ownerDelegate = adOwnerDelegate
        self.config = config
        super.init()
    }
    
   convenience init(owner:InterstitialAdRepository) {
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
        
        if canPresent(vc: vc)  {
            _loadedAd?.fullScreenContentDelegate = listener
            _loadedAd?.present(fromRootViewController: vc)
        } else {
            print("Interstitial Ad  wasn't ready")
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
    
    deinit {
        timer?.cancel()
        print("deinit","Interstitial AdWrapper")
    }
}
