//
//  AdRepositoryDelegate.swift
//  AdRepo
//
//  Created by Ali on 9/3/21.
//

import Foundation

public typealias AnyRepositoryType = any AdRepositoryProtocol
public typealias AnyAdType = any AdWrapperProtocol

public protocol AdRepositoryDelegate:NSObject{
    ///Will call after each ad receives.
    /// - Parameter repo: current native Ad repository
    func adRepository(didReceive repository:AnyRepositoryType)
    
    ///Will call when the repository finished load ads whether the process success or failed.
    /// - Parameters:
    ///   - repo:  Repository which finished the load ads process.
    ///   - error: Final error after retries base on error handler object. see **ErrorHandler.swift** for more details.
    func adRepository(didFinishLoading repository:AnyRepositoryType,error:Error?)
    
    /// Will call when a repository's ad expired. see  **AdRepositoryConfig.swift** for more detail
    /// - Parameters:
    ///   - ad: The expired ad
    ///   - repository: Repository which contains the expired ad
    func adRepository(didExpire ad:AnyAdType,in repository:AnyRepositoryType)
    
    /// Will call when a repository's ad is removed from the repository under `invalidAdcondition`. see  **AdRepository.swift** for more detail
    /// - Parameters:
    ///   - ad: The removed ad
    ///   - repository: Repository which contains the removed ad
    func adRepository(didRemove ad:AnyAdType,in repository:AnyRepositoryType)
}
extension AdRepositoryDelegate {
    
    public func adRepository(didReceive repository:AnyRepositoryType){}
    
    public func adRepository(didFinishLoading repository:AnyRepositoryType,error:Error?){}
    
    public func adRepository(didExpire ad:AnyAdType,in repository:AnyRepositoryType){}
    
    public func adRepository(didRemove ad:AnyAdType,in repository:AnyRepositoryType){}
}

