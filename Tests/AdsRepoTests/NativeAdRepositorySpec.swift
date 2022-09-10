//
//  NativeAdRepositorySpec.swift
//  AdsRepo-Unit-Tests
//
//  Created by Ali on 8/8/22.
//

import Foundation
@testable import AdsRepo
import Quick
import Nimble

class NativeAdRepositorySpec: QuickSpec {
  
    override func spec() {
        
        var repo:NativeAdRepository!
        var delegate:NativeAdRepositoryDelegateMock!
        var adCreator:AdCreatorMock!
        var adLoaderCreator:AdLoaderCreatorMock!
        
        describe("NativeAdRepositorySpec"){
            
            beforeEach {
                repo = NativeAdRepository(config: RepositoryConfig.debugNativeConfig())
                delegate = NativeAdRepositoryDelegateMock()
                repo.delegate = delegate
                adCreator = AdCreatorMock()
                repo.adCreator = adCreator
                adLoaderCreator = AdLoaderCreatorMock()
                repo.adLoaderCreator = adLoaderCreator
                
            }
            
            context("when isDisable"){
                it("true"){
                    //MARK: Preparation
                    repo.fillRepoAds()
                    
                    //MARK: Testing
                    repo.isDisable = true
                    
                    //MARK: Assertation
                    expect(repo.adsRepo.count).to(equal(0))
                    for mock in adCreator.nativeAdMocks{
                        expect(mock.nativeAdWrapperDidRemoveFromRepositoryCallsCount).to(equal(1))
                    }
                }
                it("false"){
                    
                    //MARK: Preparation
                    repo.isDisable = true
                    
                    //MARK: Testing
                    repo.isDisable = false
                    
                    //MARK: Assertation
                    expect(repo.adsRepo.count).to(equal(repo.config.size))
                    expect(delegate.nativeAdRepositoryDidReceiveCallsCount).to(equal(repo.config.size))
                    expect(delegate.nativeAdRepositoryDidFinishLoadingErrorCalled).to(beTrue())
                    let expectedCallCount = repo.config.size<=5 ? 1 : repo.config.size/5
                    expect(adLoaderCreator.callCount).to(equal(expectedCallCount))
                    expect(adLoaderCreator.isAllRequestsValied).to(beTrue())
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
                    for mock in adCreator.nativeAdMocks{
                        expect(mock.nativeAdWrapperDidRemoveFromRepositoryCallsCount).to(equal(1))
                    }
                }
                it("if reach ad become expire"){
                    
                    //MARK: Preparation
                    repo.fillRepoAds()
                    repo.adsRepo.forEach({$0.now =
                        {
                            Date().addingTimeInterval(repo.config.expireIntervalTime+1).timeIntervalSince1970
                        }()})
                    
                    //MARK: Testing
                    repo.validateRepositoryAds()
                    
                    //MARK: Assertation
                    expect(repo.adsRepo.count).to(equal(0))
                    for mock in adCreator.nativeAdMocks{
                        expect(mock.nativeAdWrapperDidRemoveFromRepositoryCallsCount).to(equal(1))
                    }
                    
                }
            }
            it("when call fillRepoAds"){
                //MARK: Testing
                repo.fillRepoAds()
                
                //MARK: Assertation
                expect(repo.adsRepo.count).to(equal(repo.config.size))
                let expectedCallCount = repo.config.size<=5 ? 1 : repo.config.size/5
                expect(adLoaderCreator.callCount).to(equal(expectedCallCount))
                expect(adLoaderCreator.isAllRequestsValied).to(beTrue())
            }
            context("when call loadAd"){
                it("if have ads"){
                    //MARK: Preparation
                    repo.fillRepoAds()
                    //MARK: Testing
                    var _adWrapper:NativeAdWrapper? = nil
                    var _ad:FakeNativeAdMock? = nil
                    
                    let hasAd = repo.loadAd(){ad in
                        _adWrapper = ad
                        _ad = _adWrapper?.loadedAd as? FakeNativeAdMock
                    }
                    //MARK: Assertation
                    let delegateMock = adCreator.nativeAdMocks.first(where: {$0 == _adWrapper?.delegate})
                    
                    expect(hasAd).to(beTrue())
                    expect(_adWrapper).toNot(beNil())
                    expect(_ad).toNot(beNil())
                    expect(_adWrapper?.showCount).to(equal(1))
                    expect(delegateMock?.nativeAdWrapperDidShowCountChangedCallsCount).to(equal(1))
                    
                    let expectedCallCount = repo.config.size<=5 ? 1 : repo.config.size/5
                    expect(adLoaderCreator.callCount).to(equal(expectedCallCount))
                    expect(adLoaderCreator.isAllRequestsValied).to(beTrue())
                }
                
                it("if empty"){
                    //MARK: Testing
                    var _adWrapper:NativeAdWrapper? = nil
                    var _ad:FakeNativeAdMock? = nil
                    
                    let hasAd = repo.loadAd(){ad in
                        _adWrapper = ad
                        _ad = _adWrapper?.loadedAd as? FakeNativeAdMock
                    }
                    //MARK: Assertation
                    expect(hasAd).to(beFalse())
                    expect(_adWrapper).to(beNil())
                    expect(_ad).to(beNil())
                    
                    //auto fill is active
                    expect(repo.adsRepo.count).to(equal(repo.config.size))
                    for mock in adCreator.interstitialAdMocks{
                        expect(mock.interstitialAdWrapperDidReadyCallsCount).to(equal(1))
                    }
                    
                    let expectedCallCount = repo.config.size<=5 ? 1 : repo.config.size/5
                    expect(adLoaderCreator.callCount).to(equal(expectedCallCount))
                    expect(adLoaderCreator.isAllRequestsValied).to(beTrue())
                }
            }
            context("when hasReadyAd check") {
                it("if have ads"){
                    //MARK: Preparation
                    repo.fillRepoAds()
                    
                    //MARK: Assertation
                    expect(repo.hasValidAd).to(beTrue())
                }
                it("if empty"){
                    //MARK: Assertation
                    expect(repo.hasAd).to(beFalse())
                }
            }
            context("when get an error"){
                //MARK: TODO
            }
        }
    }
    
}
