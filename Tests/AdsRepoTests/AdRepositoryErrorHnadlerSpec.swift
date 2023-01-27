//
//  AdRepositoryErrorHnadler.swift
//  AdsRepo-Unit-Tests
//
//  Created by Ali on 1/27/23.
//

import Foundation
import Foundation
import Quick
import Nimble
import GoogleMobileAds
@testable import AdsRepo

class AdRepositoryErrorHnadlerSpec: QuickSpec {
    
    override func spec() {
        
        describe("AdRepositoryErrorHnadler"){
            
            var errorHandler:AdRepositoryErrorHandler! = AdRepositoryErrorHandler()
            
            beforeEach {
               errorHandler = AdRepositoryErrorHandler()
            }
            context("is retryable"){
                it("if retryable"){
                    let error = NSError(domain: GADErrorDomain, code: GADErrorCode.noFill.rawValue)
                    expect(errorHandler.isRetryAble(error: error)).to(beTrue())
                }
                
                it("if not retryable"){
                    let error = NSError(domain: GADErrorDomain, code: GADErrorCode.invalidRequest.rawValue)
                    expect(errorHandler.isRetryAble(error: error)).to(beFalse())
                }
            }
            
            it("request for retry"){
                errorHandler.requestForRetry{_ in}
                
                expect(errorHandler.lastWorkItem).notTo(beNil())
                expect(errorHandler.currentRetryCount).to(equal(1))
            }
            
            it("reset"){
                errorHandler.requestForRetry{_ in}
                errorHandler.restart()
                
                expect(errorHandler.currentRetryCount).to(equal(0))
            }
            
            it("cancel"){
                
                errorHandler.requestForRetry{_ in}
                errorHandler.cancel()
                
                expect(errorHandler.lastWorkItem).to(beNil())
            }
        }
    }
}
