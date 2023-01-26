//
//  RewardedAdRepositorySpec.swift
//  AdsRepo-Unit-Tests
//
//  Created by Ali on 8/8/22.
//
import Foundation
@testable import AdsRepo
import GoogleMobileAds
import Quick
import Nimble

class RewardedAdRepositorySpec: QuickSpec {
    
    override func spec() {
        var repo:RewardedAdRepository!
        var delegate:RewardedAdRepositoryDelegateMock!
        var adCreator:AdCreatorMock!
        var errorHandler:ErrorHandlerProtocolMock!
        
        describe("RewardedAdRepositorySpec"){
            
            beforeEach {
                repo = RewardedAdRepository(config: AdRepositoryConfig.debugRewardedConfig())
                delegate = RewardedAdRepositoryDelegateMock()
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
                    for mock in adCreator.rewardedAdMocks{
                        expect(mock.rewardedAdWrapperDidRemoveFromRepositoryCallsCount).to(equal(1))
                    }
                    
                }
                it("if false"){
                    
                    //MARK: Preparation
                    repo.isDisable = true
                    
                    //MARK: Testing
                    repo.isDisable = false
                    
                    //MARK: Assertation
                    expect(delegate.rewardedAdRepositoryDidFinishLoadingErrorCalled).toEventually(beTrue())
                    expect(repo.adsRepo.count).to(equal(repo.config.size))
                    
                    for mock in adCreator.rewardedAdMocks{
                        expect(mock.rewardedAdWrapperDidReadyCallsCount).to(equal(1))
                    }
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
                    for mock in adCreator.rewardedAdMocks{
                        expect(mock.rewardedAdWrapperDidRemoveFromRepositoryCallsCount).to(equal(1))
                    }
                }
                it("if reach ad become expire"){
                    
                    //MARK: Preparation
                    repo.fillRepoAds()
                    expect(delegate.rewardedAdRepositoryDidFinishLoadingErrorCalled).toEventually(beTrue())
                    repo.adsRepo.forEach({$0.now =
                        {
                            Date().addingTimeInterval(repo.config.expireIntervalTime+1).timeIntervalSince1970
                        }()})
                    
                    //MARK: Testing
                    repo.validateRepositoryAds()
                    
                    //MARK: Assertation
                    expect(repo.adsRepo.count).to(equal(0))
                    for mock in adCreator.rewardedAdMocks{
                        expect(mock.rewardedAdWrapperDidRemoveFromRepositoryCallsCount).to(equal(1))
                    }
                    
                }
                
            }
            it("when call fillRepoAds"){
                
                //MARK: Testing
                repo.fillRepoAds()
                
                //MARK: Assertation
                expect(delegate.rewardedAdRepositoryDidFinishLoadingErrorCallsCount).toEventually(equal(1))
                expect(repo.adsRepo.count).to(equal(repo.config.size))
                
                for mock in adCreator.rewardedAdMocks{
                    expect(mock.rewardedAdWrapperDidReadyCallsCount).to(equal(1))
                }
            }
            context("when call presentAd"){
                it("if have ads"){
                    //MARK: Preparation
                    repo.fillRepoAds()
                    expect(delegate.rewardedAdRepositoryDidFinishLoadingErrorCalled).toEventually(beTrue())
                    //MARK: Testing
                    var expected_adWrapper:RewardedAdWrapper? = nil
                    var expected_ad:FakeRewardedAdMock? = nil
                    
                    let hasAd = repo.presentAd(vc: UIViewController()){ad in
                        expected_adWrapper = ad
                        expected_ad = expected_adWrapper?.loadedAd as? FakeRewardedAdMock
                        
                        expected_ad?.presentFromRootViewControllerUserDidEarnRewardHandlerClosure = {vc,rewardHandler in
                            expected_ad?.underlyingFullScreenContentDelegate?.adWillPresentFullScreenContent?(expected_ad!)
                        }
                    }
                    //MARK: Assertation
                    let delegateMock = adCreator.rewardedAdMocks.first(where: {$0 == expected_adWrapper?.delegate})

                    expect(hasAd).to(beTrue())
                    expect(expected_adWrapper).toNot(beNil())
                    expect(expected_ad).toNot(beNil())
                    expect(expected_adWrapper?.showCount).to(equal(1))
                    expect(delegateMock?.rewardedAdWrapperDidReadyCallsCount).to(equal(1))
                    expect(delegateMock?.rewardedAdWrapperWillOpenCallsCount).to(equal(1))
                    expect(delegateMock?.rewardedAdWrapperDidShowCountChangedCallsCount).to(equal(1))
                    expect(expected_ad?.presentFromRootViewControllerUserDidEarnRewardHandlerCallsCount).to(equal(1))
                }
                it("if ads have different showCount"){
                    //MARK: Preparation
                    repo.fillRepoAds()
                    expect(delegate.rewardedAdRepositoryDidFinishLoadingErrorCalled).toEventually(beTrue())
                    repo.adsRepo.forEach({$0.showCount += 1})
                    repo.adsRepo.randomElement()?.showCount = 0
                    
                    //MARK: Testing
                    var expected_adWrapper:RewardedAdWrapper? = nil
                    var expected_ad:FakeRewardedAdMock? = nil
                    let expected_to_select_ad = repo.adsRepo.min(by: {$0.showCount < $1.showCount})
                    
                    let hasAd = repo.presentAd(vc: UIViewController()){ad in
                        expected_adWrapper = ad
                        expected_ad = expected_adWrapper?.loadedAd as? FakeRewardedAdMock
                        
                        expected_ad?.presentFromRootViewControllerUserDidEarnRewardHandlerClosure = {vc,rewardHandler in
                            expected_ad?.underlyingFullScreenContentDelegate?.adWillPresentFullScreenContent?(expected_ad!)
                        }
                    }
                    //MARK: Assertation
                    let delegateMock = adCreator.rewardedAdMocks.first(where: {$0 == expected_adWrapper?.delegate})
                  

                    expect(expected_to_select_ad).to(equal(expected_adWrapper))
                    expect(hasAd).to(beTrue())
                    expect(expected_adWrapper).toNot(beNil())
                    expect(expected_ad).toNot(beNil())
                    expect(expected_adWrapper?.showCount).to(equal(1))
                    expect(delegateMock?.rewardedAdWrapperDidReadyCallsCount).to(equal(1))
                    expect(delegateMock?.rewardedAdWrapperWillOpenCallsCount).to(equal(1))
                    expect(delegateMock?.rewardedAdWrapperDidShowCountChangedCallsCount).to(equal(1))
                    expect(expected_ad?.presentFromRootViewControllerUserDidEarnRewardHandlerCallsCount).to(equal(1))
                }
                it("if empty"){
                    //MARK: Testing
                    var expected_adWrapper:RewardedAdWrapper? = nil
                    var expected_ad:FakeRewardedAdMock? = nil
                    
                    let hasAd = repo.presentAd(vc: UIViewController()){ad in
                        expected_adWrapper = ad
                        expected_ad = expected_adWrapper?.loadedAd as? FakeRewardedAdMock
                    }
                    //MARK: Assertation
                    expect(delegate.rewardedAdRepositoryDidFinishLoadingErrorCallsCount).toEventually(equal(1))
                    expect(hasAd).to(beFalse())
                    expect(expected_adWrapper).to(beNil())
                    expect(expected_ad).to(beNil())
                    
                    //auto fill is active
                    expect(repo.adsRepo.count).to(equal(repo.config.size))
                    for mock in adCreator.rewardedAdMocks{
                        expect(mock.rewardedAdWrapperDidReadyCallsCount).to(equal(1))
                    }
                    expect(errorHandler.isRetryAbleErrorRetryClosureCalled).to(beFalse())
                    expect(delegate.rewardedAdRepositoryDidFinishLoadingErrorCalled).to(beTrue())
                    expect(delegate.rewardedAdRepositoryDidFinishLoadingErrorReceivedArguments?.error).to(beNil())
                }
            }
            context("when hasReadyAd") {
                it("if has ads"){
                    //MARK: Preparation
                    repo.fillRepoAds()
                   
                    //MARK: Assertation
                    expect(delegate.rewardedAdRepositoryDidFinishLoadingErrorCalled).toEventually(beTrue())
                    expect(repo.canPresentAnyAd(vc: UIViewController())).to(beTrue())
                }
                it("if empty"){
                    //MARK: Assertation
                    expect(repo.canPresentAnyAd(vc: UIViewController())).to(beFalse())
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
                        expect(delegate.rewardedAdRepositoryDidFinishLoadingErrorCalled).toEventually(beTrue())
                        expect(errorHandler.isRetryAbleErrorRetryClosureCallsCount).to(equal(10))
                        expect(repo.adsRepo.count).to(equal(repo.config.size))
                        
                        let numberOfDidReadyCalled = adCreator.rewardedAdMocks.filter({$0.rewardedAdWrapperDidReadyCalled}).count
                        let numberOfOnErrorCalled = adCreator.rewardedAdMocks.filter({$0.rewardedAdWrapperOnErrorErrorCalled}).count
                        
                        expect(numberOfDidReadyCalled).to(equal(repo.config.size))
                        expect(numberOfOnErrorCalled).to(equal(10))
                        expect(numberOfDidReadyCalled+numberOfOnErrorCalled).to(equal(adCreator.rewardedAdMocks.count))
                    }
                    it("never success"){
                        //MARK: Preparation
                        let error = NSError(domain: GADErrorDomain, code: GADErrorCode.timeout.rawValue)
                        adCreator.responseError = error
                        var counter = 0;
                        let numberOfRetry = AdRepositoryErrorHandlerConfig.defaultMaxRetryCount
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
                        expect(delegate.rewardedAdRepositoryDidFinishLoadingErrorCallsCount).toEventually(equal(1))
                        expect(retryCount).to(equal(AdRepositoryErrorHandlerConfig.defaultMaxRetryCount))
                        expect(repo.adsRepo.count).to(equal(0))
                        
                        let numberOfOnErrorCalled = adCreator.rewardedAdMocks.filter({$0.rewardedAdWrapperOnErrorErrorCallsCount == 1}).count

                        expect(numberOfOnErrorCalled).to(equal(retryCount + repo.config.size))//(+ repo.config.size) for last time calll
                        expect(delegate.rewardedAdRepositoryDidFinishLoadingErrorCallsCount).to(equal(1))
                        let resultError = delegate.rewardedAdRepositoryDidFinishLoadingErrorReceivedArguments?.error as? NSError
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
                    expect(delegate.rewardedAdRepositoryDidFinishLoadingErrorCallsCount).toEventually(equal(1))
                    expect(errorHandler.isRetryAbleErrorRetryClosureCallsCount).to(equal(2))
                    expect(repo.adsRepo.count).to(equal(0))
                    
                    let numberOfOnErrorCalled = adCreator.rewardedAdMocks.filter({$0.rewardedAdWrapperOnErrorErrorCallsCount == 1}).count
                    expect(numberOfOnErrorCalled).to(equal(2))
                    expect(numberOfOnErrorCalled).to(equal(adCreator.rewardedAdMocks.count))
                    expect(delegate.rewardedAdRepositoryDidFinishLoadingErrorCalled).to(beTrue())
                    let resultError = delegate.rewardedAdRepositoryDidFinishLoadingErrorReceivedArguments?.error as? NSError
                    expect(resultError).to(equal(error))
                }
            }
        }
    }
    
}
