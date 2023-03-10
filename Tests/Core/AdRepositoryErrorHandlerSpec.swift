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
@testable import AdsRepo

class AdRepositoryErrorHnadlerSpec: QuickSpec {
    
    override func spec() {
        
        describe("AdRepositoryErrorHnadler"){
            
            var errorHandler:DefaultErrorHandler!
            
            beforeEach {
               errorHandler = DefaultErrorHandler()
            }
            
            it("if retryable"){
                    let error = NSError(domain: "AnyDomain", code: 0)//any type of error
                    expect(errorHandler.isRetryAble(error: error)).to(beTrue())
            }
            
            it("request for retry"){
                //Testing
                errorHandler.requestForRetry{_ in}
                
                //Assertation
                expect(errorHandler.lastWorkItem).notTo(beNil())
                expect(errorHandler.currentRetryCount).to(equal(1))
            }
            
            it("reset"){
                //Preparation
                errorHandler.requestForRetry{_ in}
                
                //Testing
                errorHandler.restart()
                
                //Assertation
                expect(errorHandler.currentRetryCount).to(equal(0))
            }
            
            it("cancel"){
                //Preparation
                errorHandler.requestForRetry{_ in}
                
                //Testing
                errorHandler.cancel()
                
                //Assertation
                expect(errorHandler.lastWorkItem).to(beNil())
            }
        }
    }
}
