//
//  RewardedAdsRepositorySpec.swift
//  AdsRepo-Unit-Tests
//
//  Created by Ali on 8/8/22.
//
import Foundation
@testable import AdsRepo
import Quick
import Nimble

class RewardedAdsRepositorySpec: QuickSpec {
    
    override func spec() {
        var repo:RewardedAdsRepository!
        var delegate:RewardedAdsRepositoryDelegate!
        var adCreator:AdCreatorMock!
        
        describe("RewardedAdsRepositorySpec"){
            
            beforeEach {
                repo = RewardedAdsRepository(config: RepoConfig.debugRewardedConfig())
                delegate = RewardedAdsRepositoryDelegateMock()
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
                    expect(repo.adsRepo.count).to(equal(repo.config.repoSize))
                    
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
                    for mock in adCreator.rewardedAdMocks{
                        expect(mock.rewardedAdWrapperDidRemoveFromRepositoryCallsCount).to(equal(1))
                    }
                    
                }
                
            }
            it("when call fillRepoAds"){
                
                //MARK: Testing
                repo.fillRepoAds()
                
                //MARK: Assertation
                expect(repo.adsRepo.count).to(equal(repo.config.repoSize))
                
                for mock in adCreator.rewardedAdMocks{
                    expect(mock.rewardedAdWrapperDidReadyCallsCount).to(equal(1))
                }
            }
            context("when call presentAd"){
                it("if have ads"){
                    //MARK: Preparation
                    repo.fillRepoAds()
                    //MARK: Testing
                    var _adWrapper:RewardedAdWrapper? = nil
                    var _ad:FakeRewardedAdMock? = nil
                    
                    repo.presentAd(vc: UIViewController()){ad in
                        _adWrapper = ad
                        _ad = _adWrapper?.loadedAd as? FakeRewardedAdMock
                        
                        _ad?.presentFromRootViewControllerUserDidEarnRewardHandlerClosure = {vc,earnHandler in
                            _ad?.underlyingFullScreenContentDelegate?.adDidPresentFullScreenContent?(_ad!)
                        }
                    }
                    //MARK: Assertation
                    let delegateMock = adCreator.rewardedAdMocks.first(where: {$0 == _adWrapper?.delegate})
                    expect(_adWrapper).toNot(beNil())
                    expect(_ad).toNot(beNil())
                    expect(_adWrapper?.showCount).to(equal(1))
                    expect(delegateMock?.rewardedAdWrapperDidReadyCallsCount).to(equal(1))
                    expect(delegateMock?.rewardedAdWrapperDidOpenCallsCount).to(equal(1))
                    expect(delegateMock?.rewardedAdWrapperDidShowCountChangedCallsCount).to(equal(1))
                    expect(_ad?.presentFromRootViewControllerUserDidEarnRewardHandlerCallsCount).to(equal(1))
                }
                
                it("if empty"){
                    //MARK: Testing
                    var _adWrapper:RewardedAdWrapper? = nil
                    var _ad:FakeRewardedAdMock? = nil
                    
                    repo.presentAd(vc: UIViewController()){ad in
                        _adWrapper = ad
                        _ad = _adWrapper?.loadedAd as? FakeRewardedAdMock
                    }
                    //MARK: Assertation
                    expect(_adWrapper).to(beNil())
                    expect(_ad).to(beNil())
                    
                    //auto fill is active
                    expect(repo.adsRepo.count).to(equal(repo.config.repoSize))
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
            it("if get an error"){
                //MARK: TODO
            }
        }
    }
    
}
