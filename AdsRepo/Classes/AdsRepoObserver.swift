//
//  AdRepoObserver.swift
//  AdRepo
//
//  Created by Ali on 9/3/21.
//

import Foundation

public protocol AdsRepoDelegate:RewardedAdsRepositoryDelegate,
                                NativeAdsRepositoryDelegate,
                                InterstitialAdsRepositoryDelegate {}

public protocol AdsRepoObserver:AdsRepoDelegate {
    var observerId:String{get}
}

protocol AdsRepoObservable {
    var observers : [Weak<AdsRepoObserver>] { get set }
    func addObserver(observer: AdsRepoObserver)
    func removeObserver(observer: AdsRepoObserver)
    func removeObserver(observerId: String)
}

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
