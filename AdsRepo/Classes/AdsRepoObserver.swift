//
//  Observer.swift
//  AdMobManager
//
//  Created by Ali on 9/3/21.
//

import Foundation

public protocol AdsRepoDelegate {
    func adsRepoDelegate(didReady ad:RewardAdWrapper)
    func adsRepoDelegate(didOpen ad:RewardAdWrapper)
    func adsRepoDelegate(willClose ad:RewardAdWrapper)
    func adsRepoDelegate(didClose ad:RewardAdWrapper)
    func adsRepoDelegate(onError ad:RewardAdWrapper,error:Error?)
    func adsRepoDelegate(didReward ad:RewardAdWrapper,reward:Double)
    func adsRepoDelegate(didExpire ad:RewardAdWrapper)
    
    func adsRepoDelegate(didReady ad:InterstitialAdWrapper)
    func adsRepoDelegate(didOpen ad:InterstitialAdWrapper)
    func adsRepoDelegate(willClose ad:InterstitialAdWrapper)
    func adsRepoDelegate(didClose ad:InterstitialAdWrapper)
    func adsRepoDelegate(onError ad:InterstitialAdWrapper,error:Error?)
    func adsRepoDelegate(didExpire ad:InterstitialAdWrapper)
    
    func didReceiveNativeAds()
    func didFinishLoadingNativeAds()
    func didFailToReceiveNativeAdWithError(_ error: Error)
    func adsRepoDelegate(didExpire ad:NativeAdWrapperProtocol)
}
public extension AdsRepoDelegate {
    func adsRepoDelegate(didReady ad:RewardAdWrapper){}
    func adsRepoDelegate(didOpen ad:RewardAdWrapper){}
    func adsRepoDelegate(willClose ad:RewardAdWrapper){}
    func adsRepoDelegate(didClose ad:RewardAdWrapper){}
    func adsRepoDelegate(onError ad:RewardAdWrapper,error:Error?){}
    func adsRepoDelegate(didReward ad:RewardAdWrapper,reward:Double){}
    func adsRepoDelegate(didExpire ad:RewardAdWrapper){}
    
    func adsRepoDelegate(didReady ad:InterstitialAdWrapper){}
    func adsRepoDelegate(didOpen ad:InterstitialAdWrapper){}
    func adsRepoDelegate(willClose ad:InterstitialAdWrapper){}
    func adsRepoDelegate(didClose ad:InterstitialAdWrapper){}
    func adsRepoDelegate(onError ad:InterstitialAdWrapper,error:Error?){}
    func adsRepoDelegate(didExpire ad:InterstitialAdWrapper){}
    
    func didReceiveNativeAds(){}
    func didFinishLoadingNativeAds(){}
    func didFailToReceiveNativeAdWithError(_ error: Error){}
    func adsRepoDelegate(didExpire ad:NativeAdWrapperProtocol){}
}

public protocol AdsRepoObserver:AnyObject,AdsRepoDelegate {
    var observerId:String{get}
}

protocol AdsRepoObservable {
    var observers : [Weak<AdsRepoObserver>] { get set }
    func addObserver(observer: AdsRepoObserver)
    func removeObserver(observer: AdsRepoObserver)
    func removeObserver(observerId: String)
}

//public class WeakArray<T:AnyObject> {
//    private let pointers = NSPointerArray.weakObjects()
//
//    init (_ elements: T...) {
//        elements.forEach{self.pointers.addPointer(Unmanaged.passUnretained($0).toOpaque())}
//    }
//
//    func get (_ index: Int) -> T? {
//        if index < self.pointers.count, let pointer = self.pointers.pointer(at: index) {
//            return Unmanaged<T>.fromOpaque(pointer).takeUnretainedValue()
//        } else {
//            return nil
//        }
//    }
//    func append (_ element: T) {
//        self.pointers.addPointer(Unmanaged.passUnretained(element).toOpaque())
//    }
//    func remove(at index:Int){
//        guard index < self.pointers.count else {return}
//        self.pointers.removePointer(at: index)
//    }
//    func removeAll(_ element: T){
//        for index in 0..<self.pointers.count{
//            if let pointer =  self.pointers.pointer(at: index){
//                let obj:T = Unmanaged<T>.fromOpaque(pointer).takeUnretainedValue()
//                if obj === element {
//                    remove(at: index)
//                }
//            }
//        }
//    }
//
//    func forEach (_ callback: (T) -> ()) {
//        for i in 0..<self.pointers.count {
//            if let element = self.get(i) {
//                callback(element)
//            }
//        }
//    }
//}

struct Weak<T> {
    var value: T? { provider() }
    private let provider: () -> T?

    init(_ object: T) {
        // Any Swift value can be "promoted" to an AnyObject, however,
        // that doesn't automatically turn it into a reference.
        let reference = object as AnyObject

        provider = { [weak reference] in
            reference as? T
        }
    }
}
