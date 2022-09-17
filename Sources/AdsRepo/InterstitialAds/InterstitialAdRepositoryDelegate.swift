//
//  InterstitialAdRepositoryDelegate.swift
//  AdsRepo
//
//  Created by Ali on 8/29/22.
//

import Foundation
public protocol InterstitialAdRepositoryDelegate:NSObject {
    ///Will call after each ad receives
    /// - Parameter repo: current native Ad repository
    func interstitialAdRepository(didReceive repo:InterstitialAdRepository)
    ///Will call after repository fill or can't handle error any more.
    /// - Parameters:
    ///   - repo: Current native Ad repository
    ///   - error: Final error after retries base on error handler object. see **ErrorHandler.swift** for more details
    func interstitialAdRepository(didFinishLoading repo:InterstitialAdRepository,error:Error?)
}

extension InterstitialAdRepositoryDelegate {
    public func interstitialAdRepository(didReceive repo:InterstitialAdRepository){}
    public func interstitialAdRepository(didFinishLoading repo:InterstitialAdRepository,error:Error?){}
}
