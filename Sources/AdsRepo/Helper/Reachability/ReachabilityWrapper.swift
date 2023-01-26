//
//  ReachabilityWrapper.swift
//  AdsRepo
//
//  Created by Ali on 1/26/23.
//

import Foundation
class ReachabilityWrapper:ReachabilityPorotocol{
   
    
    
    private var reachability = try? Reachability()
    
    var isConnected: Bool {
        switch reachability?.connection {
        case .wifi,.cellular:
            return true
        default:
            return false
        }
    }
    
    func setBackOnlineNotifier(_ notifier:OnConnectedType?) {
        reachability?.whenReachable = {[weak self] reachability in
            guard let self = self else{return}
            notifier?(self)
        }
    }
    
    func startNotifier() {
        try? reachability?.startNotifier()
    }
    
    func stopNotifier() {
        self.reachability?.stopNotifier()
    }
    
}
