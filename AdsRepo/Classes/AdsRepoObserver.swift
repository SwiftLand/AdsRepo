//
//  Observer.swift
//  AdMobManager
//
//  Created by Ali on 9/3/21.
//

import Foundation

public protocol AdsRepoDelegate {
    func adMobManagerDelegate(didReady ad:RewardAdWrapper)
    func adMobManagerDelegate(didOpen ad:RewardAdWrapper)
    func adMobManagerDelegate(willClose ad:RewardAdWrapper)
    func adMobManagerDelegate(didClose ad:RewardAdWrapper)
    func adMobManagerDelegate(onError ad:RewardAdWrapper,error:Error?)
    func adMobManagerDelegate(didReward ad:RewardAdWrapper,reward:Double)
    
    
    func adMobManagerDelegate(didReady ad:InterstitialAdWrapper)
    func adMobManagerDelegate(didOpen ad:InterstitialAdWrapper)
    func adMobManagerDelegate(willClose ad:InterstitialAdWrapper)
    func adMobManagerDelegate(didClose ad:InterstitialAdWrapper)
    func adMobManagerDelegate(onError ad:InterstitialAdWrapper,error:Error?)
    
    func didReceiveNativeAds()
    func didFinishLoadingNativeAds()
    func didFailToReceiveNativeAdWithError(_ error: Error)
}
public extension AdsRepoDelegate {
    func adMobManagerDelegate(didReady ad:RewardAdWrapper){}
    func adMobManagerDelegate(didOpen ad:RewardAdWrapper){}
    func adMobManagerDelegate(willClose ad:RewardAdWrapper){}
    func adMobManagerDelegate(didClose ad:RewardAdWrapper){}
    func adMobManagerDelegate(onError ad:RewardAdWrapper,error:Error?){}
    func adMobManagerDelegate(didReward ad:RewardAdWrapper,reward:Double){}
    
    
    func adMobManagerDelegate(didReady ad:InterstitialAdWrapper){}
    func adMobManagerDelegate(didOpen ad:InterstitialAdWrapper){}
    func adMobManagerDelegate(willClose ad:InterstitialAdWrapper){}
    func adMobManagerDelegate(didClose ad:InterstitialAdWrapper){}
    func adMobManagerDelegate(onError ad:InterstitialAdWrapper,error:Error?){}
    
    func didReceiveNativeAds(){}
    func didFinishLoadingNativeAds(){}
    func didFailToReceiveNativeAdWithError(_ error: Error){}
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
