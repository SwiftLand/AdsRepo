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
        var delegate:InterstitialAdRepositoryDelegate!
        var adCreator:AdCreatorMock!
        
        describe("InterstitialAdRepository"){
            
            beforeEach {
                repo = InterstitialAdRepository(config: RepositoryConfig.debugInterstitialConfig())
                delegate = InterstitialAdRepositoryDelegateMock()
                repo.delegate = delegate
                adCreator = AdCreatorMock()
                repo.adCreator = adCreator
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
                    expect(repo.adsRepo.count).to(equal(repo.config.size))
                    
                    for mock in adCreator.interstitialAdMocks{
                        expect(mock.interstitialAdWrapperDidReadyCallsCount).to(equal(1))
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
                    for mock in adCreator.interstitialAdMocks{
                        expect(mock.interstitialAdWrapperDidRemoveFromRepositoryCallsCount).to(equal(1))
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
                    for mock in adCreator.interstitialAdMocks{
                        expect(mock.interstitialAdWrapperDidRemoveFromRepositoryCallsCount).to(equal(1))
                    }
                    
                }
                
            }
            it("when call fillRepoAds"){
                
                //MARK: Testing
                repo.fillRepoAds()
                
                //MARK: Assertation
                expect(repo.adsRepo.count).to(equal(repo.config.size))
                
                for mock in adCreator.interstitialAdMocks{
                    expect(mock.interstitialAdWrapperDidReadyCallsCount).to(equal(1))
                }
            }
            context("when call presentAd"){
                it("if have ads"){
                    //MARK: Preparation
                    repo.fillRepoAds()
                    //MARK: Testing
                    var _adWrapper:InterstitialAdWrapper? = nil
                    var _ad:FakeInterstitialAdMock? = nil
                    
                    let hasAd = repo.presentAd(vc: UIViewController()){ad in
                        _adWrapper = ad
                        _ad = _adWrapper?.loadedAd as? FakeInterstitialAdMock
                        
                        _ad?.presentFromRootViewControllerClosure = {vc in
                            _ad?.underlyingFullScreenContentDelegate?.adDidPresentFullScreenContent?(_ad!)
                        }
                    }
                    //MARK: Assertation
                    let delegateMock = adCreator.interstitialAdMocks.first(where: {$0 == _adWrapper?.delegate})
                    
                    expect(hasAd).to(beTrue())
                    expect(_adWrapper).toNot(beNil())
                    expect(_ad).toNot(beNil())
                    expect(_adWrapper?.showCount).to(equal(1))
                    expect(delegateMock?.interstitialAdWrapperDidReadyCallsCount).to(equal(1))
                    expect(delegateMock?.interstitialAdWrapperDidOpenCallsCount).to(equal(1))
                    expect(delegateMock?.interstitialAdWrapperDidShowCountChangedCallsCount).to(equal(1))
                    expect(_ad?.presentFromRootViewControllerCallsCount).to(equal(1))
                }
                
                it("if empty"){
                    //MARK: Testing
                    var _adWrapper:InterstitialAdWrapper? = nil
                    var _ad:FakeInterstitialAdMock? = nil
                    
                    let hasAd = repo.presentAd(vc: UIViewController()){ad in
                        _adWrapper = ad
                        _ad = _adWrapper?.loadedAd as? FakeInterstitialAdMock
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
                    
                }
            }
            context("when hasReadyAd") {
                it("if have ads"){
                    //MARK: Preparation
                    repo.fillRepoAds()
                    
                    //MARK: Assertation
                    expect(repo.hasReadyAd(vc: UIViewController())).to(beTrue())
                }
                it("if empty"){
                    //MARK: Assertation
                    expect(repo.hasReadyAd(vc: UIViewController())).to(beFalse())
                }
            }
            context("when get an error"){
                //MARK: TODO
            }
        }
    }
    
}
