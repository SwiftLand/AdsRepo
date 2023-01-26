//
//  ReachabilityPorotocol.swift
//  AdsRepo
//
//  Created by Ali on 1/26/23.
//

import Foundation
protocol ReachabilityPorotocol {
    typealias OnConnectedType = (ReachabilityPorotocol) -> ()
    
    var isConnected:Bool{get}
    
    func setBackOnlineNotifier(_ notifier:OnConnectedType?)
    
    func startNotifier()
    func stopNotifier()
}
