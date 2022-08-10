//
//  NativeAdWrapper.swift
//  AdRepo
//
//  Created by Ali on 9/2/21.
//

import Foundation
import GoogleMobileAds

public protocol NativeAdWrapperDelegate:NSObject {
    func nativeAdWrapper(didRemoveFromRepository ad:NativeAdWrapper)
    func nativeAdWrapper(didShowCountChanged ad:NativeAdWrapper)
    func nativeAdWrapper(didExpire ad:NativeAdWrapper)
}
extension NativeAdWrapperDelegate {
    public func nativeAdWrapper(didRemoveFromRepository ad:NativeAdWrapper){}
    public func nativeAdWrapper(didShowCountChanged ad:NativeAdWrapper){}
    public func nativeAdWrapper(didExpire ad:NativeAdWrapper){}
}

public class NativeAdWrapper:NSObject{
    public private(set) var config:RepoConfig
    public private(set) var loadedAd: GADNativeAd
    public private(set) var loadedDate:TimeInterval = Date().timeIntervalSince1970
    public private(set) var showCount:Int = 0
    public private(set) weak var owner:NativeAdRepository? = nil
    public  weak var delegate:NativeAdWrapperDelegate? = nil
    public private(set) var isValid:Bool = true
    
    private lazy var timer: DispatchSourceTimer = {
        let t = DispatchSource.makeTimerSource(queue:DispatchQueue.main)
        t.schedule(deadline: .now() +  config.expireIntervalTime)
        t.setEventHandler(handler: { [weak self] in
            guard let self = self else {return}
            print("Native Ad was expire")
            self.delegate?.nativeAdWrapper(didExpire: self)
            self.owner?.notifyAdChange()
        })
        return t
    }()
    
    init(loadedAd: GADNativeAd,owner:NativeAdRepository) {
        self.config = owner.config
        self.loadedAd = loadedAd
        super.init()
        self.owner = owner
        timer.resume()
    }
    
    internal func increaseShowCount(){
        showCount += 1
        delegate?.nativeAdWrapper(didShowCountChanged: self)
        owner?.notifyAdChange()
    }
    
    internal func removeFromRepository(){//call when ad expire
         isValid = false
         timer.cancel()
         delegate?.nativeAdWrapper(didRemoveFromRepository: self)
    }
    
    deinit {
        timer.cancel()
        print("deinit","Native Ad")
    }
}
