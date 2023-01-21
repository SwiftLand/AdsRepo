//
//  AdRepoObserver.swift
//  AdRepo
//
//  Created by Ali on 9/3/21.
//

import Foundation

public protocol AdRepositoryDelegate:NSObject{
    ///Will call after each ad receives
    /// - Parameter repo: current native Ad repository
    
    func adRepository(didReceive repository:any AdRepositoryProtocol)
    ///Will call after repository fill or can't handle error any more.
    /// - Parameters:
    ///   - repo: Current native Ad repository
    ///   - error: Final error after retries base on error handler object. see **ErrorHandler.swift** for more details
    func adRepository(didFinishLoading repository:any AdRepositoryProtocol,error:Error?)
    
    func adRepository(didExpire ad:any AdWrapperProtocol,in repository:any AdRepositoryProtocol)
    
    func adRepository(didRemove ad:any AdWrapperProtocol,in repository:any AdRepositoryProtocol)
}
extension AdRepositoryDelegate {
    
    public func adRepository(didReceive repository:any AdRepositoryProtocol){}
    
    public func adRepository(didFinishLoading repository:any AdRepositoryProtocol,error:Error?){}
    
    public func adRepository(didExpire ad:any AdWrapperProtocol,in repository:any AdRepositoryProtocol){}
    
    public func adRepository(didRemove ad:any AdWrapperProtocol,in repository:any AdRepositoryProtocol){}
}

