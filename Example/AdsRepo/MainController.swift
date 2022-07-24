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
    
    @IBOutlet weak var nativeBannerCollectionViewBtn: UIButton!
    @IBOutlet weak var nativeCollectionViewBtn: UIButton!
    @IBOutlet weak var nativeTableViewBtn: UIButton!
    @IBOutlet weak var nativeBannerTableViewBtn: UIButton!
    @IBOutlet weak var imageNativeAdbtn: UIButton!
    @IBOutlet weak var VideoNativeAdBtn: UIButton!
    @IBOutlet weak var rewardedAdBtn: UIButton!
    @IBOutlet weak var interstinalAdBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AdsRepo.default.addObserver(observer: self)
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(_ animated: Bool) {
        interstinalAdBtn.setTitle("Interstinal Ad (loaded:\(loadedInterstinalAdCount))", for: .normal)
        rewardedAdBtn.setTitle("Rewarded Ad (loaded:\(loadedRewardedAdCount))", for: .normal)
    }
    override func viewDidAppear(_ animated: Bool) {
        RepositoryManager.shared.fillAllRepositories()
//        ATTHelper.request{status in
////            RepositoryManager.shared.fillAllRepositories()
//        }
    }
    
    @IBAction func onUserAction (_ sender:UIControl){
        switch sender{
        case nativeCollectionViewBtn:
           let vc = CollectionViewNativeAdVC.instantiate()
            vc.adRepository = RepositoryManager.shared.nativeBannerAdRepo
            vc.type = .largeBanner
            navigationController?.pushViewController(vc, animated: true)
        case nativeBannerCollectionViewBtn:
           let vc = CollectionViewNativeAdVC.instantiate()
            vc.adRepository = RepositoryManager.shared.nativeBannerAdRepo
            vc.type = .banner
            navigationController?.pushViewController(vc, animated: true)
        case nativeTableViewBtn:break
        case imageNativeAdbtn:
           let vc =  FullScreenNativeAdVC.instantiate()
            vc.adRepository = RepositoryManager.shared.nativeImageAdRepo
           navigationController?.pushViewController(vc, animated: true)
        case VideoNativeAdBtn:
            let vc =  FullScreenNativeAdVC.instantiate()
            vc.adRepository = RepositoryManager.shared.nativeVideoAdRepo
            navigationController?.pushViewController(vc, animated: true)
        case rewardedAdBtn:
            RepositoryManager.shared.rewardedAdsRepo.presentAd(vc: self){
             [weak self] rewardAd in
                rewardAd.delegate = self
            }
        case interstinalAdBtn:
            RepositoryManager.shared.interstitialAdsRepo.presentAd(vc: self) {
             [weak self] interstitialAd in
                interstitialAd.delegate = self
            }
        default:break
        }
    }
}
extension MainController:AdsRepoObserver{
    
    func interstitialAdsRepository(didReceive repo: InterstitialAdsRepository) {
        loadedInterstinalAdCount = repo.adsRepo.count
    }
    func interstitialAdsRepository(didFinishLoading repo: InterstitialAdsRepository, error: Error?) {
        if error == nil{
            print("Repo(\(repo.config.adUnitId)) is full, count:\(repo.adsRepo.count)")
        }else{
            print("Repo(\(repo.config.adUnitId)) have error:\(String(describing: error))")
        }
        
    }
    
    func rewardedAdsRepository(didReceiveAds repo: RewardedAdsRepository) {
        loadedRewardedAdCount =  repo.adsRepo.count
    }
    
    func rewardedAdsRepository(didFinishLoading repo: RewardedAdsRepository, error: Error?) {
        if error == nil{
            print("Repo(\(repo.config.adUnitId)) is full, count:\(repo.adsRepo.count)")
        }else{
            print("Repo(\(repo.config.adUnitId)) have error:\(String(describing: error))")
        }
    }
}
extension MainController:InterstitialAdWrapperDelegate{
    func interstitialAd(didRemoveFromRepository ad: InterstitialAdWrapper) {
        loadedInterstinalAdCount = ad.owner?.adsRepo.count ?? 0
    }
}
extension MainController:RewardAdWrapperDelegate{
    func rewardAd(didRemoveFromRepository ad: RewardAdWrapper) {
        loadedRewardedAdCount = ad.owner?.adsRepo.count ?? 0
    }
}
