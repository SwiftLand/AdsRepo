//
//  AdRepoObserver.swift
//  AdRepo
//
//  Created by Ali on 9/3/21.
//

import Foundation

public protocol AdsRepoDelegate:RewardedAdRepositoryDelegate,
                                NativeAdRepositoryDelegate,
                                InterstitialAdRepositoryDelegate {}

protocol AdsRepoObservable {
    var observers : [Weak<AdsRepoDelegate>] { get set }
    func addObserver(observer: AdsRepoDelegate)
    func removeObserver(observer: AdsRepoDelegate)
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
