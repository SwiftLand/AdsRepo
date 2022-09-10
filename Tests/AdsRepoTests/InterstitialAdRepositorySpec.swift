//
//  InterstitialAdRepositorySpec.swift
//  AdsRepo-Unit-Tests
//
//  Created by Ali on 8/8/22.
//
import Foundation
import GoogleMobileAds
@testable import AdsRepo
import Quick
import Nimble

class InterstitialAdRepositorySpec: QuickSpec {
    
    override func spec() {
        var repo:InterstitialAdRepository!
        var delegate:InterstitialAdRepositoryDelegateMock!
        var adCreator:AdCreatorMock!
        var errorHandler:ErrorHandlerProtocolMock!
        
        describe("InterstitialAdRepository"){
            
            beforeEach {
                repo = InterstitialAdRepository(config: RepositoryConfig.debugInterstitialConfig())
                delegate = InterstitialAdRepositoryDelegateMock()
                repo.delegate = delegate
                adCreator = AdCreatorMock()
                repo.adCreator = adCreator
                errorHandler = ErrorHandlerProtocolMock()
                repo.errorHandler = errorHandler
            }
            
            context("when isDisable"){
                it("if true"){
                    
                    //MARK: Testing
                    repo.fillRepoAds()
                    repo.isDisable = true
                    
                    //MARK: Assertation
                    expect(repo.adsRepo.count).to(equal(0))
                    for mock in adCreator.interstitialAdMocks{
                        expect(mock.interstitialAdWrapperDidRemoveFromRepositoryCallsCount).to(equal(1))
                    }
                }
                it("if false"){
                    
                    //MARK: Preparation
                    repo.isDisable = true
                    
                    //MARK: Testing
                    repo.isDisable = false
                    
                    //MARK: Assertation
                    expect(delegate.interstitialAdRepositoryDidFinishLoadingErrorCallsCount).toEventually(equal(1))
                    expect(repo.adsRepo.count).to(equal(repo.config.size))
                    
                    for mock in adCreator.interstitialAdMocks{
                        expect(mock.interstitialAdWrapperDidReadyCallsCount).to(equal(1))
                    }
                    expect(delegate.interstitialAdRepositoryDidFinishLoadingErrorCalled).to(beTrue())
                    expect(errorHandler.isRetryAbleErrorRetryClosureCalled).to(beFalse())
                    expect(delegate.interstitialAdRepositoryDidFinishLoadingErrorReceivedArguments?.error).to(beNil())
                }
            }
            context("when call validateRepositoryAds"){
                it("if reach the showCountThreshold"){
                    
                    //MARK: Preparation
                    repo.fillRepoAds()
                    repo.adsRepo.forEach({$0.showCount = $0.config.showCountThreshold+1})
                    
                    //MARK: Testing
                    repo.validateRepositoryAds()
                    
                    //MARK: Assertation
                    expect(repo.adsRepo.count).to(equal(0))
                    for mock in adCreator.interstitialAdMocks{
                        expect(mock.interstitialAdWrapperDidRemoveFromRepositoryCallsCount).to(equal(1))
                    }
                }
                it("if reach ad become expire"){
                    
                    //MARK: Preparation
                    repo.fillRepoAds()
                    expect(delegate.interstitialAdRepositoryDidFinishLoadingErrorCalled).toEventually(beTrue())
                    
                    repo.adsRepo.forEach({$0.now =
                        {
                            Date().addingTimeInterval(repo.config.expireIntervalTime+1).timeIntervalSince1970
                        }()})
    
                    //MARK: Testing
                    repo.validateRepositoryAds()
                    
                    //MARK: Assertation
                    expect(repo.adsRepo.count).to(equal(0))
                    for mock in adCreator.interstitialAdMocks{
                        expect(mock.interstitialAdWrapperDidRemoveFromRepositoryCallsCount).to(equal(1))
                    }
                    
                }
                
            }
            it("when call fillRepoAds"){
                
                //MARK: Testing
                repo.fillRepoAds()
                
                //MARK: Assertation
                expect(delegate.interstitialAdRepositoryDidFinishLoadingErrorCallsCount).toEventually(equal(1))
                expect(repo.adsRepo.count).to(equal(repo.config.size))
                
                for mock in adCreator.interstitialAdMocks{
                    expect(mock.interstitialAdWrapperDidReadyCallsCount).to(equal(1))
                }
                expect(errorHandler.isRetryAbleErrorRetryClosureCalled).to(beFalse())
                expect(delegate.interstitialAdRepositoryDidFinishLoadingErrorCalled).to(beTrue())
                expect(delegate.interstitialAdRepositoryDidFinishLoadingErrorReceivedArguments?.error).to(beNil())
            }
            context("when call presentAd"){
                it("if has ads"){
                    //MARK: Preparation
                    repo.fillRepoAds()
                    expect(delegate.interstitialAdRepositoryDidFinishLoadingErrorCalled).toEventually(beTrue())
                    //MARK: Testing
                    var expected_adWrapper:InterstitialAdWrapper? = nil
                    var expected_ad:FakeInterstitialAdMock? = nil
                    
                    let hasAd = repo.presentAd(vc: UIViewController()){ad in
                        expected_adWrapper = ad
                        expected_ad = expected_adWrapper?.loadedAd as? FakeInterstitialAdMock
                        
                        expected_ad?.presentFromRootViewControllerClosure = {vc in
                            expected_ad?.underlyingFullScreenContentDelegate?.adWillPresentFullScreenContent?(expected_ad!)
                        }
                    }
                    //MARK: Assertation
                    let delegateMock = adCreator.interstitialAdMocks.first(where: {$0 == expected_adWrapper?.delegate})

                    expect(hasAd).to(beTrue())
                    expect(expected_adWrapper).toNot(beNil())
                    expect(expected_ad).toNot(beNil())
                    expect(expected_adWrapper?.showCount).to(equal(1))
                    expect(delegateMock?.interstitialAdWrapperDidReadyCallsCount).to(equal(1))
                    expect(delegateMock?.interstitialAdWrapperWillOpenCallsCount).to(equal(1))
                    expect(delegateMock?.interstitialAdWrapperDidShowCountChangedCallsCount).to(equal(1))
                    expect(expected_ad?.presentFromRootViewControllerCallsCount).to(equal(1))
                }
                it("if ads have different showCount"){
                    //MARK: Preparation
                    repo.fillRepoAds()
                    expect(delegate.interstitialAdRepositoryDidFinishLoadingErrorCalled).toEventually(beTrue())
                    repo.adsRepo.forEach({$0.showCount += 1})
                    repo.adsRepo.randomElement()?.showCount = 0
                    
                    //MARK: Testing
                    var expected_adWrapper:InterstitialAdWrapper? = nil
                    var expected_ad:FakeInterstitialAdMock? = nil
                    let expected_to_select_ad = repo.adsRepo.min(by: {$0.showCount < $1.showCount})
                    
                    let hasAd = repo.presentAd(vc: UIViewController()){ad in
                        expected_adWrapper = ad
                        expected_ad = expected_adWrapper?.loadedAd as? FakeInterstitialAdMock
                        
                        expected_ad?.presentFromRootViewControllerClosure = {vc in
                            expected_ad?.underlyingFullScreenContentDelegate?.adWillPresentFullScreenContent?(expected_ad!)
                        }
                    }
                    //MARK: Assertation
                    let delegateMock = adCreator.interstitialAdMocks.first(where: {$0 == expected_adWrapper?.delegate})
                  

                    expect(expected_to_select_ad).to(equal(expected_adWrapper))
                    expect(hasAd).to(beTrue())
                    expect(expected_adWrapper).toNot(beNil())
                    expect(expected_ad).toNot(beNil())
                    expect(expected_adWrapper?.showCount).to(equal(1))
                    expect(delegateMock?.interstitialAdWrapperDidReadyCallsCount).to(equal(1))
                    expect(delegateMock?.interstitialAdWrapperWillOpenCallsCount).to(equal(1))
                    expect(delegateMock?.interstitialAdWrapperDidShowCountChangedCallsCount).to(equal(1))
                    expect(expected_ad?.presentFromRootViewControllerCallsCount).to(equal(1))
                }
                it("if empty"){
                    //MARK: Testing
                    var expected_adWrapper:InterstitialAdWrapper? = nil
                    var expected_ad:FakeInterstitialAdMock? = nil
                    
                    let hasAd = repo.presentAd(vc: UIViewController()){ad in
                        expected_adWrapper = ad
                        expected_ad = expected_adWrapper?.loadedAd as? FakeInterstitialAdMock
                    }
                    //MARK: Assertation
                    expect(delegate.interstitialAdRepositoryDidFinishLoadingErrorCallsCount).toEventually(equal(1))
                    expect(hasAd).to(beFalse())
                    expect(expected_adWrapper).to(beNil())
                    expect(expected_ad).to(beNil())
                    
                    //auto fill is active
                    expect(repo.adsRepo.count).to(equal(repo.config.size))
                    for mock in adCreator.interstitialAdMocks{
                        expect(mock.interstitialAdWrapperDidReadyCallsCount).to(equal(1))
                    }
                    expect(errorHandler.isRetryAbleErrorRetryClosureCalled).to(beFalse())
                    expect(delegate.interstitialAdRepositoryDidFinishLoadingErrorCalled).to(beTrue())
                    expect(delegate.interstitialAdRepositoryDidFinishLoadingErrorReceivedArguments?.error).to(beNil())
                }
            }
            context("when hasReadyAd") {
                it("if have ads"){
                    //MARK: Testing
                    repo.fillRepoAds()
                    
                    //MARK: Assertation
                    expect(delegate.interstitialAdRepositoryDidFinishLoadingErrorCalled).toEventually(beTrue())
                    expect(repo.hasReadyAd(vc: UIViewController())).to(beTrue())
                }
                it("if empty"){
                    //MARK: Assertation
                    expect(repo.hasReadyAd(vc: UIViewController())).to(beFalse())
                }
            }
            context("when get an error"){
                context("if retryable"){
                   it("and finally success"){
                        //MARK: Preparation
                        adCreator.responseError = NSError(domain: GADErrorDomain, code: GADErrorCode.timeout.rawValue)
                        
                        var counter = 0;
                        errorHandler.isRetryAbleErrorRetryClosureClosure = {error,retryClosure in
                            counter += 1
                            if (counter>=10) {
                                adCreator.responseError = nil
                            }
                            DispatchQueue.main.async{
                                retryClosure?()
                            }
                            return true
                        }
                        
                        //MARK: Testing
                        repo.fillRepoAds()
                        
                        //MARK: Assertation
                        expect(delegate.interstitialAdRepositoryDidFinishLoadingErrorCalled).toEventually(beTrue())
                        expect(errorHandler.isRetryAbleErrorRetryClosureCallsCount).to(equal(10))
                        expect(repo.adsRepo.count).to(equal(repo.config.size))
                        
                        let numberOfDidReadyCalled = adCreator.interstitialAdMocks.filter({$0.interstitialAdWrapperDidReadyCalled}).count
                        let numberOfOnErrorCalled = adCreator.interstitialAdMocks.filter({$0.interstitialAdWrapperOnErrorErrorCalled}).count
                        
                        expect(numberOfDidReadyCalled).to(equal(repo.config.size))
                        expect(numberOfOnErrorCalled).to(equal(10))
                        expect(numberOfDidReadyCalled+numberOfOnErrorCalled).to(equal(adCreator.interstitialAdMocks.count))
                    }
                    it("never success"){
                        //MARK: Preparation
                        let error = NSError(domain: GADErrorDomain, code: GADErrorCode.timeout.rawValue)
                        adCreator.responseError = error
                        var counter = 0;
                        let numberOfRetry = ErrorHandlerConfig.defaultMaxRetryCount
                        var retryCount:Int = 0
                        
                        errorHandler.isRetryAbleErrorRetryClosureClosure = {error,retryClosure in
                            counter += 1
                            guard (counter<=numberOfRetry) else{
                                return false
                            }
                            DispatchQueue.main.async{
                                retryClosure?()
                            }
                            retryCount += 1
                            return true
                        }
                        
                        //MARK: Testing
                        repo.fillRepoAds()
                        
                        //MARK: Assertation
                        expect(delegate.interstitialAdRepositoryDidFinishLoadingErrorCallsCount).toEventually(equal(1))
                        expect(retryCount).to(equal(ErrorHandlerConfig.defaultMaxRetryCount))
                        expect(repo.adsRepo.count).to(equal(0))
                        
                        let numberOfOnErrorCalled = adCreator.interstitialAdMocks.filter({$0.interstitialAdWrapperOnErrorErrorCallsCount == 1}).count

                        expect(numberOfOnErrorCalled).to(equal(retryCount + repo.config.size))//(+ repo.config.size) for last time calll
                        expect(delegate.interstitialAdRepositoryDidFinishLoadingErrorCallsCount).to(equal(1))
                        let resultError = delegate.interstitialAdRepositoryDidFinishLoadingErrorReceivedArguments?.error as? NSError
                        expect(resultError).to(equal(error))
                    }
                }
                it("if not retryable"){
                    let error = NSError(domain: GADErrorDomain, code: GADErrorCode.invalidRequest.rawValue)
                    adCreator.responseError = error
                    errorHandler.isRetryAbleErrorRetryClosureReturnValue = false
                    //MARK: Testing
                    repo.fillRepoAds()
                    
                    //MARK: Assertation
                    expect(delegate.interstitialAdRepositoryDidFinishLoadingErrorCallsCount).toEventually(equal(1))
                    expect(errorHandler.isRetryAbleErrorRetryClosureCallsCount).to(equal(2))
                    expect(repo.adsRepo.count).to(equal(0))
                    
                    let numberOfOnErrorCalled = adCreator.interstitialAdMocks.filter({$0.interstitialAdWrapperOnErrorErrorCallsCount == 1}).count
                    expect(numberOfOnErrorCalled).to(equal(2))
                    expect(numberOfOnErrorCalled).to(equal(adCreator.interstitialAdMocks.count))
                    expect(delegate.interstitialAdRepositoryDidFinishLoadingErrorCalled).to(beTrue())
                    let resultError = delegate.interstitialAdRepositoryDidFinishLoadingErrorReceivedArguments?.error as? NSError
                    expect(resultError).to(equal(error))
                }
            }
        }
    }
    
}
