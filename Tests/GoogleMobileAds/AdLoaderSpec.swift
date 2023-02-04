//
//  AdLoaderSpec.swift
//  AdsRepo-Unit-Tests
//
//  Created by Ali on 1/27/23.
//

import Foundation
import Quick
import Nimble
import GoogleMobileAds
@testable import AdsRepo

#if SWIFT_PACKAGE
@testable import AdsRepo_GoogleMobileAds
#endif

class AdLoaderSpec: QuickSpec {
    
    override func spec() {
        
        describe("AdLoader"){
            
            let config = AdRepositoryConfig(adUnitId: "sample", size: 2)
            
            
            itBehavesLike(AdLoaderBehavior.self){
                let adLoader = InterstitialAdLoader(config: config)
                adLoader.Loader = GADInterstitialAdMock.self
                return adLoader
            }
            itBehavesLike(AdLoaderBehavior.self){
                let adLoader = RewardedAdLoader(config: config)
                adLoader.Loader = GADRewardedAdMock.self
                return adLoader
            }
            
            itBehavesLike(AdLoaderBehavior.self){
                let adLoader = NativeAdLoader(config: config)
                adLoader.Loader = GADAdLoaderMock.self
                return adLoader
            }
        }
    }
}

private class AdLoaderBehavior<T:AdLoaderProtocol>: Behavior<T> {
    
    
    override class func spec(_ context: @escaping () -> T) {
        
        describe("AdLoaderSpec"){
            
            let config = AdRepositoryConfig(adUnitId: "sample", size: 2)
            var adloader:T!
            
            beforeEach {
                adloader = context()
                ErrorController.removeErrorForAllRequests()
            }
            
            it("if success"){
                //Testing
                let tester = AdLoaderTester<T>(adloader: adloader)
                tester.startTest()
                
                //Assertation
                expect(tester.numberOfNotifyRepositoryDidReceiveAdCalled).to(equal(config.size),description: "test1")
                expect(tester.numberOfNotifyRepositoryDidFinishLoadCalled).to(equal(1),description: "test2")
                expect(tester.receivedAd).notTo(beNil(),description: "test3")
                expect(tester.receivedError).to(beNil(),description: "test4")
            }
            
            it("if failed"){
                //Preparation
                ErrorController.setErrorForAllRequests()
                
                //Testing
                let tester = AdLoaderTester<T>(adloader: adloader)
                tester.startTest()
                
                //Assertation
                expect(tester.numberOfNotifyRepositoryDidReceiveAdCalled).to(equal(0),description: "test1")
                expect(tester.numberOfNotifyRepositoryDidFinishLoadCalled).to(equal(1),description: "test2")
                expect(tester.receivedAd).to(beNil(),description: "test3")
                expect(tester.receivedError).notTo(beNil(),description: "test4")
                expect(tester.receivedError?.code).to(equal(ErrorController.error.code),description: "test5")
            }
        }
    }
}

private class AdLoaderTester<T:AdLoaderProtocol>{
    
    var numberOfNotifyRepositoryDidReceiveAdCalled = 0
    var numberOfNotifyRepositoryDidFinishLoadCalled = 0
    var receivedError:NSError? = nil
    var receivedAd:(T.AdWrapperType)? = nil
    let adloader:T
    
    init(adloader:T){
        self.adloader = adloader
    }
    
    func setNotifiers(){
        
        adloader.notifyRepositoryDidReceiveAd = { ad in
            self.numberOfNotifyRepositoryDidReceiveAdCalled += 1
            self.receivedAd = ad
        }
        
        adloader.notifyRepositoryDidFinishLoad = {
            error in
            self.numberOfNotifyRepositoryDidFinishLoadCalled += 1
            self.receivedError = error as? NSError
        }
    }
    
    func startTest(count:Int = 2){
        setNotifiers()
        adloader.load(count: count)
    }
}


private final class ErrorController{
    static let error = NSError(domain: GADErrorDomain, code: GADErrorCode.invalidRequest.rawValue)

    static func setErrorForAllRequests(){
        GADInterstitialAdMock.error = error
        GADRewardedAdMock.error = error
        GADAdLoaderMock.error = error
    }
    
    static func removeErrorForAllRequests(){
        GADInterstitialAdMock.error = nil
        GADRewardedAdMock.error = nil
        GADAdLoaderMock.error = nil
    }
}



