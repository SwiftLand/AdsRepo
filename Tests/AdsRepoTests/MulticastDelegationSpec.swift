//
//  MulticastDelegationSpec.swift
//  AdsRepo-Unit-Tests
//
//  Created by Ali on 1/27/23.
//

import Foundation
import Quick
import Nimble
@testable import AdsRepo

class MulticastDelegationSpec: QuickSpec {
    
    override func spec() {
        
        describe("MulticastDelegationSpec"){
            
            var multicast:MulticastDelegate<AdRepositoryDelegateMock>!
            
            beforeEach {
                multicast = .init()
            }
            
            context("when add"){
                
                it("same items"){
                    //Pereparing
                    let delegate = AdRepositoryDelegateMock()
                    
                    //Testing
                    for _ in 0..<10 {
                        multicast.append(delegate: delegate)
                    }
                    
                    //Assertation
                    expect(multicast.count).to(equal(1))
                }
                
                it("diffrent items"){
                    //Pereparing
                    var delegates:[AdRepositoryDelegateMock] = [] //<- to prevent remove refrence before expect
                    
                    //Testing
                    for _ in 0..<10 {
                        let delegate = AdRepositoryDelegateMock()
                        delegates.append(delegate)
                        multicast.append(delegate: delegate)
                    }
                    
                    //Assertation
                    expect(multicast.count).to(equal(10))
                }
            }
            
            context("when remove"){
                it("existence item"){
                    //Pereparing
                    let delegate = AdRepositoryDelegateMock()
                    multicast.append(delegate: delegate)
                    
                    //Testing
                    multicast.remove(delegate: delegate)
                    
                    //Assertation
                    expect(multicast.count).to(equal(0))
                }
                
                it("none existence item"){
                    //Pereparing
                    let delegate = AdRepositoryDelegateMock()
                    
                    //Testing
                    multicast.remove(delegate: delegate)
                    
                    //Assertation
                    expect(multicast.count).to(equal(0))
                }
            }
            context("when invoke"){
                var fakeRepo:InterstitalAdRepository!
                
                beforeEach {
                    fakeRepo = InterstitalAdRepository(config: .init(adUnitId: "sample", size: 2))
                }
                
                it("single item"){
                    //Pereparing
                    let delegate = AdRepositoryDelegateMock()
                    multicast.append(delegate: delegate)
                    
                    //Testing
                    multicast.invoke{
                        $0.adRepository(didReceive: fakeRepo)
                    }
                    
                    //Assertation
                    expect(delegate.adRepositoryDidReceiveCallsCount).to(equal(1))
                }
                it("many items"){
                    //Pereparing
                    var delegates:[AdRepositoryDelegateMock] = []
                    
                    for _ in 0..<10{
                        let delegate = AdRepositoryDelegateMock()
                        delegates.append(delegate)
                        multicast.append(delegate: delegate)
                    }
                    
                    //Testing
                    multicast.invoke{
                        $0.adRepository(didReceive: fakeRepo)
                    }
                    
                    //Assertation
                    for delegate in delegates{
                        expect(delegate.adRepositoryDidReceiveCallsCount).to(equal(1))
                    }
                }
            }
        }
    }
}
