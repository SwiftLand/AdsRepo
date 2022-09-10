//
//  InterstitialAdWrapper.swift
//  AdRepo
//
//  Created by Ali on 9/3/21.
//

import Foundation
import GoogleMobileAds


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
