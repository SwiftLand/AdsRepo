//
//  AdRepoObserver.swift
//  AdRepo
//
//  Created by Ali on 9/3/21.
//

import Foundation

public typealias AnyRepositoryType = any AdRepositoryProtocol
public typealias AnyAdType = any AdWrapperProtocol

public protocol AdRepositoryDelegate:NSObject{
    ///Will call after each ad receives
    /// - Parameter repo: current native Ad repository
    
    func adRepository(didReceive repository:AnyRepositoryType)
    ///Will call after repository fill or can't handle error any more.
    /// - Parameters:
    ///   - repo: Current native Ad repository
    ///   - error: Final error after retries base on error handler object. see **ErrorHandler.swift** for more details
    func adRepository(didFinishLoading repository:AnyRepositoryType,error:Error?)
    
    func adRepository(didExpire ad:AnyAdType,in repository:AnyRepositoryType)
    
    func adRepository(didRemove ad:AnyAdType,in repository:AnyRepositoryType)
}
extension AdRepositoryDelegate {
    
    public func adRepository(didReceive repository:AnyRepositoryType){}
    
    public func adRepository(didFinishLoading repository:AnyRepositoryType,error:Error?){}
    
    public func adRepository(didExpire ad:AnyAdType,in repository:AnyRepositoryType){}
    
    public func adRepository(didRemove ad:AnyAdType,in repository:AnyRepositoryType){}
}

