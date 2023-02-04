//
//  GADAdRepository.swift
//  
//
//  Created by Ali on 2/5/23.
//

import Foundation

#if SWIFT_PACKAGE
import AdsRepo
#endif

public class GADAdRepository<AdType:AdWrapperProtocol,loaderType:AdLoaderProtocol>:
    AdRepository<AdType, loaderType> where loaderType.AdWrapperType == AdType{
    
    public override init(config: AdRepositoryConfig) {
        super.init(config: config)
        super.errorHandler = GADErrorHandler()
    }
}
