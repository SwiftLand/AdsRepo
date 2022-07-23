//
//  ViewController.swift
//  AdsRepo
//
//  Created by x-oauth-basic on 09/04/2021.
//  Copyright (c) 2021 x-oauth-basic. All rights reserved.
//

import UIKit
import AdsRepo
class MainController: UIViewController {
    
    var observerId: String =  "\(NSStringFromClass(MainController.self))"
    var loadedInterstinalAdCount = 0{
        didSet{
            interstinalAdBtn.setTitle("Interstinal Ad (loaded:\(loadedInterstinalAdCount))", for: .normal)
        }
    }
    var loadedRewardedAdCount = 0{
        didSet{
            rewardedAdBtn.setTitle("Rewarded Ad (loaded:\(loadedRewardedAdCount))", for: .normal)
        }
    }
    
    @IBOutlet weak var nativeCollectionViewBtn: UIButton!
    @IBOutlet weak var nativeTableViewBtn: UIButton!
    @IBOutlet weak var imageNativeAdbtn: UIButton!
    @IBOutlet weak var VideoNativeAdBtn: UIButton!
    @IBOutlet weak var rewardedAdBtn: UIButton!
    @IBOutlet weak var interstinalAdBtn: UIButton!
    
    let interstitialAdsController: InterstitialAdsController = {
        let adController = InterstitialAdsController(config:RepoConfig.debugInterstitialConfig())
        adController.fillRepoAds()
        return adController
    }()
    let rewardedAdsController: RewardedAdsController = {
        let adController = RewardedAdsController(config:RepoConfig.debugRewardedConfig())
        adController.fillRepoAds()
        return adController
    }()
    
    let nativeVideoAdController: NativeAdsController = {
        let adController = NativeAdsController(config:RepoConfig.debugNativeVideoConfig())
        adController.fillRepoAds()
        return adController
    }()
    let nativeImageAdController: NativeAdsController = {
        let adController = NativeAdsController(config:RepoConfig.debugNativeConfig())
        adController.fillRepoAds()
        return adController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AdsRepo.default.addObserver(observer: self)
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(_ animated: Bool) {
        interstinalAdBtn.setTitle("Interstinal Ad (loaded:\(loadedInterstinalAdCount))", for: .normal)
        rewardedAdBtn.setTitle("Rewarded Ad (loaded:\(loadedRewardedAdCount))", for: .normal)
    }
    
    @IBAction func onUserAction (_ sender:UIControl){
        switch sender{
        case nativeCollectionViewBtn:break
        case nativeTableViewBtn:break
        case imageNativeAdbtn:
           let vc =  FullScreenNativeAdController.instantiate(nativeImageAdController)
           navigationController?.pushViewController(vc, animated: true)
        case VideoNativeAdBtn:
            let vc =  FullScreenNativeAdController.instantiate(nativeVideoAdController)
            navigationController?.pushViewController(vc, animated: true)
        case rewardedAdBtn:
            rewardedAdsController.presentAd(vc: self)
        case interstinalAdBtn:
            interstitialAdsController.presentAd(vc: self)
        default:break
        }
    }
}
extension MainController:AdsRepoObserver{
    
    func interstitialAdsController(didReceive repo: InterstitialAdsController) {
        loadedInterstinalAdCount = repo.adsRepo.count
    }
    func interstitialAdsController(didFinishLoading repo: InterstitialAdsController, error: Error?) {
        if error == nil{
            print("Repo(\(repo.config.adUnitId)) is full, count:\(repo.adsRepo.count)")
        }else{
            print("Repo(\(repo.config.adUnitId)) have error:\(String(describing: error))")
        }
        
    }
    func rewardedAdsController(didReceiveAds repo: RewardedAdsController) {
        loadedRewardedAdCount =  repo.adsRepo.count
    }
    func rewardedAdsController(didFinishLoading repo: RewardedAdsController, error: Error?) {
        if error == nil{
            print("Repo(\(repo.config.adUnitId)) is full, count:\(repo.adsRepo.count)")
        }else{
            print("Repo(\(repo.config.adUnitId)) have error:\(String(describing: error))")
        }
    }
}
