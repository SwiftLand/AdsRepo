//
//  AdRepositoryErrorHandlerEx.swift
//  AdsRepo
//
//  Created by Ali on 2/3/23.
//

import Foundation
import Foundation
import Quick
import Nimble
import GoogleMobileAds
@testable import AdsRepo

#if SWIFT_PACKAGE
@testable import AdsRepo_GoogleMobileAds
#endif

class GADAdRepositoryErrorHandlerSpec: QuickSpec {
    
    override func spec() {
        
        describe("GoogleMobileAds ErrorHnadler"){
            
            var errorHandler:AdRepositoryErrorHandlerProtocol!
            
            beforeEach {
               errorHandler = GADErrorHandler()
            }
            
            context("is GoogleMobileAds retryable"){
                it("if retryable"){
                    let error = NSError(domain: GADErrorDomain, code: GADErrorCode.noFill.rawValue)
                    expect(errorHandler.isRetryAble(error: error)).to(beTrue())
                }
                
                it("if not retryable"){
                    let error = NSError(domain: GADErrorDomain, code: GADErrorCode.invalidRequest.rawValue)
                    expect(errorHandler.isRetryAble(error: error)).to(beFalse())
                }
            }
        }
    }
}
