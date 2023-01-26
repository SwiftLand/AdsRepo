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
    
    func setBackOnlineNotifier(_ notifier:BackOnlineNotifierClosure?)
    
    func startNotifier()
    func stopNotifier()
}
