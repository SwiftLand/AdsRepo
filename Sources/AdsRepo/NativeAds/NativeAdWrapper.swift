//
//  NativeAdWrapper.swift
//  AdRepo
//
//  Created by Ali on 9/2/21.
//

import Foundation
import GoogleMobileAds

public class NativeAdWrapper:NSObject{
    
    /// Repository configuration. See **RepositoryConfig.swift** for more details.
    public private(set) var config:RepositoryConfig
    
    /// GADNativeAd object that loaded successfully with adLoader inside `owner` Repository object
    public private(set) var loadedAd: GADNativeAd
    
    /// Show GADNativeAd load Date (In milisecond)
    public private(set) var loadedDate:TimeInterval = Date().timeIntervalSince1970
    
    /// Show how many time this object return as valid ads to user. See **`loadAd`** function in **NativeAdRepository.swift** for more details
    public internal(set) var showCount:Int = 0
    
    /// Keep a weak reference of the current object owner. an `owner` is a repository object that will interact with this object.
    public private(set) weak var owner:NativeAdRepositoryProtocol? = nil
    
    /// Keep a weak reference of `NativeAdWrapperDelegate`. See **NativeAdWrapperDelegate.swift** for more details
    public weak var delegate:NativeAdWrapperDelegate? = nil
    
    /// Become `false` When this AdWrapper removed from repostiry otherwise it's true.
    public private(set) var isValid:Bool = true
    
    //Keep the `now` object as a variable to make the unit test easy to change the current time
    internal var now:TimeInterval = {Date().timeIntervalSince1970}()
    
    /// Protocol to communicate `NativeAdWrapper` with its own repository
    internal weak var ownerDelegate:NativeAdOwnerDelegate? = nil
    
    //Interval timer to expire date that's declared in repository config
    private lazy var timer: DispatchSourceTimer = {
        let t = DispatchSource.makeTimerSource(queue:DispatchQueue.main)
        t.schedule(deadline: .now() +  config.expireIntervalTime)
        t.setEventHandler(handler: { [weak self] in
            guard let self = self else {return}
            print("Native Ad was expire")
            self.delegate?.nativeAdWrapper(didExpire: self)
            self.ownerDelegate?.adWrapper(didExpire: self)
        })
        return t
    }()
    
    init(loadedAd: GADNativeAd,owner:NativeAdRepositoryProtocol,
         ownerDelegate:NativeAdOwnerDelegate,
         config:RepositoryConfig){
        
        self.config = config
        self.loadedAd = loadedAd
        self.owner = owner
        self.ownerDelegate = ownerDelegate
        
        super.init()
    }
    
   convenience init(loadedAd: GADNativeAd,owner:NativeAdRepository) {
       self.init(loadedAd: loadedAd, owner: owner,ownerDelegate:owner, config: owner.config)
       timer.resume()
    }
    
    func increaseShowCount(){
        showCount += 1
        delegate?.nativeAdWrapper(didShowCountChanged: self)
    }
    
    func removeFromRepository(){
         isValid = false
         timer.cancel()
         delegate?.nativeAdWrapper(didRemoveFromRepository: self)
    }
    
    deinit {
        timer.cancel()
        print("deinit","Native Ad")
    }
}
