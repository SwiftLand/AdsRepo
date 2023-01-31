//
//  ReachabilityPorotocol.swift
//  AdsRepo
//
//  Created by Ali on 1/26/23.
//

import Foundation
public protocol AdRepositoryReachabilityPorotocol {
    
    typealias BackOnlineNotifierClosure = (AdRepositoryReachabilityPorotocol) -> ()
    
    var isConnected:Bool{get}
    
    /// The default repository will use this function when `isConnected` returns `false` and will wait until the internet comes back online.
    /// - Parameter notifier:will call input closure when internet back online.
    func setBackOnlineNotifier(_ notifier:BackOnlineNotifierClosure?)
    
    
    /// Start listening to network state change
    func startNotifier()
    
    /// stop listening to network state change
    func stopNotifier()
}
