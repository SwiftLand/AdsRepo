//
//  AdRepositorySpec.swift
//  AdsRepo-Unit-Tests
//
//  Created by Ali on 8/8/22.
//
import Foundation
import Quick
import Nimble
import GoogleMobileAds
@testable import AdsRepo

class AdRepositorySpec: QuickSpec {
    
    override func spec() {
        
        describe("AdRepository"){
            
            let repoConfig = AdRepositoryConfig.debugNativeConfig()
            var repo:AdRepository<NativeAd,NativeAdLoaderMock>!
            var delegate:AdRepositoryDelegateMock!
            var errorHandler:AdRepositoryErrorHandlerProtocolMock!
         
            beforeEach {
                repo = AdRepository<NativeAd,NativeAdLoaderMock>(config:repoConfig)
                delegate = AdRepositoryDelegateMock()
                errorHandler = AdRepositoryErrorHandlerProtocolMock()
                repo.errorHandler = errorHandler
                repo.append(delegate: delegate)
            }
            
            context("when isDisable"){
                it("if true"){
                    //Pereparing
                    repo.fillRepoAds()
                    let ads = repo.adsRepo
                    
                    //Testing
                    repo.isDisable = true
                    
                    //Assertation
                    expect(repo.adsRepo.count).to(equal(0))
                    expect(delegate.adRepositoryDidRemoveInCallsCount).to(equal(repoConfig.size))
                    for ad in ads{
                        let isContain = delegate.adRepositoryDidRemoveInReceivedInvocations.contains(where: {$0.ad == ad})
                        expect(isContain).to(beTrue())
                    }
                }
                it("if false"){
                    
                    //Preparation
                    repo.isDisable = true
                    repo.autoFill = true
                    
                    //Testing
                    repo.isDisable = false
                    
                    //Assertation
                    expect(delegate.adRepositoryDidFinishLoadingErrorCallsCount).to(equal(1))
                    expect(delegate.adRepositoryDidReceiveCallsCount).to(equal(repoConfig.size))
                    expect(repo.adsRepo.count).to(equal(repo.config.size))
                }
            }
            context("when call validateRepositoryAds"){
                it("if ad reach the showCount threshold"){
                    
                    //Preparation
                    repo.fillRepoAds()
                    let ads = repo.adsRepo
                    repo.adsRepo.forEach({$0.showCount = $0.config.showCountThreshold+1})
                    
                    //Testing
                    repo.validateRepositoryAds()
                    
                    //Assertation
                    expect(repo.adsRepo.count).to(equal(0))
                    expect(delegate.adRepositoryDidRemoveInCallsCount).to(equal(repoConfig.size))
                    for ad in ads{
                        let isContain = delegate.adRepositoryDidRemoveInReceivedInvocations.contains(where: {$0.ad == ad})
                        expect(isContain).to(beTrue())
                    }
                    repo.remove(delegate: delegate)
                }
                
                //MARK: TODO <---------
                xit("if ad become expire"){
                    
                    //Preparation
                    repo.fillRepoAds()
                    let ads = repo.adsRepo

//                    Nimble.AsyncDefaults.timeout = .seconds(2)
                    let timeTravel = Date().addingTimeInterval(repo.config.expireIntervalTime+1)
                    Date.overrideCurrentDate(timeTravel)
                    
                    //Testing
                    repo.validateRepositoryAds()
                    
                    //Assertation
                    expect(repo.adsRepo.count).to(equal(0))
                    expect(delegate.adRepositoryDidRemoveInCallsCount).to(equal(repoConfig.size))
                    expect(ads.count).to(equal(repoConfig.size))
                    for ad in ads{
                        let isContain = delegate.adRepositoryDidRemoveInReceivedInvocations.contains(where: {$0.ad == ad})
                        expect(isContain).to(beTrue())
                    }
                    
                }
                
            }
            it("when call fillRepoAds"){
                
                //Testing
                repo.fillRepoAds()
                
                //Assertation
                expect(delegate.adRepositoryDidFinishLoadingErrorCallsCount).toEventually(equal(1))
                expect(delegate.adRepositoryDidReceiveCallsCount).to(equal(repoConfig.size))
                expect(repo.adsRepo.count).to(equal(repo.config.size))
                
                for ad in repo.adLoader.loadedAds{
                    expect(repo.adsRepo.contains(where: {$0 == ad})).to(beTrue())
                }
            }
            
            context("when get an error"){
                context("if retryable"){
                   it("and finally success"){
                        //Preparation
                       repo.adLoader.responseError = NSError(domain: GADErrorDomain, code: GADErrorCode.timeout.rawValue)
                        
                        var counter = 0;
                        let numberOfRetry = AdRepositoryErrorHandler.maxRetryCount/2
                      
                        errorHandler.isRetryAbleErrorReturnValue = true
                        errorHandler.requestForRetryOnRetryClosure = {retryClosure in
                            counter += 1
                            if (counter >= numberOfRetry) {
                                repo.adLoader.responseError = nil
                            }
                            retryClosure(counter)
                        }
                        
                        //Testing
                        repo.fillRepoAds()
                        
                        //Assertation
                        expect(delegate.adRepositoryDidFinishLoadingErrorCalled).toEventually(beTrue())
                        expect(errorHandler.requestForRetryOnRetryCallsCount).to(equal(numberOfRetry))
                        expect(delegate.adRepositoryDidReceiveCallsCount).to(equal(repoConfig.size))
                        expect(repo.adsRepo.count).to(equal(repo.config.size))
                       
                    }
                    it("never success"){
                        //Preparation
                        let error = NSError(domain: GADErrorDomain, code: GADErrorCode.timeout.rawValue)
                        repo.adLoader.responseError = error
                        
                        var counter = 0;
                        let numberOfRetry = AdRepositoryErrorHandler.maxRetryCount
                        
                        errorHandler.isRetryAbleErrorClosure = {error in
                            guard (counter < numberOfRetry) else{
                                return false
                            }
                            return true
                        }
                        
                        errorHandler.requestForRetryOnRetryClosure = {retryClosure in
                            counter += 1
                            retryClosure(counter)
                        }
                        
                        //Testing
                        repo.fillRepoAds()
                        
                        //Assertation
                        expect(errorHandler.requestForRetryOnRetryCallsCount).to(equal(numberOfRetry))
                        expect(delegate.adRepositoryDidReceiveCalled).to(beFalse())
                        expect(delegate.adRepositoryDidFinishLoadingErrorCallsCount).to(equal(1))
                        for inv in delegate.adRepositoryDidFinishLoadingErrorReceivedInvocations{
                            expect((inv.error as? NSError)?.code).to(equal(error.code))
                        }
                    }
                }
                it("if not retryable"){
                    //Preparation
                    let error = NSError(domain: GADErrorDomain, code: GADErrorCode.invalidRequest.rawValue)
                    repo.adLoader.responseError = error
                    errorHandler.isRetryAbleErrorReturnValue = false
                    
                    //Testing
                    repo.fillRepoAds()
                    
                    //Assertation
                    expect(delegate.adRepositoryDidFinishLoadingErrorCallsCount).to(equal(1))
                    expect(errorHandler.requestForRetryOnRetryCallsCount).to(equal(0))
                    expect(repo.adsRepo.count).to(equal(0))
                    for inv in delegate.adRepositoryDidFinishLoadingErrorReceivedInvocations{
                        expect((inv.error as? NSError)?.code).to(equal(error.code))
                    }
                }
            }
        }
    }
    
}
