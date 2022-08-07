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
    public private(set) var repoConfig:RepoConfig
    public private(set) var loadedAd: GADNativeAd
    public private(set) var loadedDate:TimeInterval = Date().timeIntervalSince1970
    public private(set) var showCount:Int = 0
    public private(set) weak var owner:NativeAdsRepository? = nil
    public  weak var delegate:NativeAdWrapperDelegate? = nil
    public var isValid:Bool = true
    
    private weak var timer:Timer? = nil
    init(loadedAd: GADNativeAd,owner:NativeAdsRepository) {
        self.repoConfig = owner.config
        self.loadedAd = loadedAd
        super.init()
        self.owner = owner
        startExpireInterval()
    }
    
    private func startExpireInterval(){
        timer = Timer.scheduledTimer(withTimeInterval: repoConfig.expireIntervalTime*1000,
                                     repeats: false,
                                     block: {[weak self]  timer in
            
            guard let self = self else {return}
            print("Native Ad was expire")
            self.delegate?.nativeAdWrapper(didExpire: self)
            self.owner?.notifyAdChange()
        })
    }
    
    public func increaseShowCount(){
        showCount += 1
        delegate?.nativeAdWrapper(didShowCountChanged: self)
        owner?.notifyAdChange()
    }
    
    func removeFromRepository(){//call when ad expire
         isValid = false
         delegate?.nativeAdWrapper(didRemoveFromRepository: self)
    }
    
    deinit {
        timer?.invalidate()
        timer = nil
        print("deinit","Native Ad")
    }
}

extension NativeAdWrapper{
    static func == (lhs: NativeAdWrapper, rhs: NativeAdWrapper) -> Bool{
        lhs.loadedAd == rhs.loadedAd
    }
}
