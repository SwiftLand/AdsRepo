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
