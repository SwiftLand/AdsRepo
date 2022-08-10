//
//  ViewController.swift
//  AdsRepo
//
//  Created by x-oauth-basic on 09/04/2021.
//  Copyright (c) 2021 x-oauth-basic. All rights reserved.
//

import UIKit
import AdsRepo
import AppTrackingTransparency
class MainController: UIViewController {
    
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
    
    var loadedNativeAdCount = 0{
        didSet{
            nativeBannerCollectionViewBtn.setTitle("Native banner ad in collection view (loaded:\(loadedNativeAdCount))", for: .normal)
            nativeCollectionViewBtn.setTitle("Native ad in collection view (loaded:\(loadedNativeAdCount))", for: .normal)
            imageNativeAdbtn.setTitle("Full screen Image Native ad (loaded:\(loadedNativeAdCount))", for: .normal)
        }
    }
    var loadedVideoNativeAdCount = 0{
        didSet{
            VideoNativeAdBtn.setTitle("Full screen Video Native ad (loaded:\(loadedVideoNativeAdCount))", for: .normal)
        }
    }
    
    @IBOutlet weak var nativeBannerCollectionViewBtn: UIButton!
    @IBOutlet weak var nativeCollectionViewBtn: UIButton!
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
        
        nativeBannerCollectionViewBtn.setTitle("Native banner ad in collection view (loaded:\(loadedNativeAdCount))", for: .normal)
        nativeCollectionViewBtn.setTitle("Native ad in collection view (loaded:\(loadedNativeAdCount))", for: .normal)
        imageNativeAdbtn.setTitle("Full screen Image Native ad (loaded:\(loadedNativeAdCount))", for: .normal)
        
        VideoNativeAdBtn.setTitle("Full screen Video Native ad (loaded:\(loadedVideoNativeAdCount))", for: .normal)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        ATTHelper.request{status in
            RepositoryManager.shared.fillAllRepositories()
        }
    }
    
    @IBAction func onUserAction (_ sender:UIControl){
        switch sender{
        case nativeCollectionViewBtn:
           let vc = CollectionViewNativeAdVC.instantiate()
            vc.adRepository = RepositoryManager.shared.nativeAdRepo
            vc.type = .largeBanner
            navigationController?.pushViewController(vc, animated: true)
        case nativeBannerCollectionViewBtn:
           let vc = CollectionViewNativeAdVC.instantiate()
            vc.adRepository = RepositoryManager.shared.nativeAdRepo
            vc.type = .banner
            navigationController?.pushViewController(vc, animated: true)
        case imageNativeAdbtn:
           let vc =  FullScreenNativeAdVC.instantiate()
            vc.adRepository = RepositoryManager.shared.nativeAdRepo
           navigationController?.pushViewController(vc, animated: true)
        case VideoNativeAdBtn:
            let vc =  FullScreenNativeAdVC.instantiate()
            vc.adRepository = RepositoryManager.shared.nativeVideoAdRepo
            navigationController?.pushViewController(vc, animated: true)
        case rewardedAdBtn:
            RepositoryManager.shared.rewardedAdsRepo.presentAd(vc: self){
             [weak self] rewardAd in
                rewardAd?.delegate = self
            }
        case interstinalAdBtn:
            RepositoryManager.shared.interstitialAdsRepo.presentAd(vc: self) {
             [weak self] interstitialAd in
                interstitialAd?.delegate = self
            }
        default:break
        }
    }
}
extension MainController:AdsRepoDelegate{
    
    func interstitialAdRepository(didReceive repo: InterstitialAdRepository) {
        loadedInterstinalAdCount = repo.adsRepo.count
    }
    func interstitialAdRepository(didFinishLoading repo: InterstitialAdRepository, error: Error?) {
        if error == nil{
            print("Repo(\(repo.config.adUnitId)) is full, count:\(repo.adsRepo.count)")
        }else{
            print("Repo(\(repo.config.adUnitId)) have error:\(String(describing: error))")
        }
        
    }
    
    func rewardedAdRepository(didReceiveAds repo: RewardedAdRepository) {
        loadedRewardedAdCount =  repo.adsRepo.count
    }
    
    func rewardedAdRepository(didFinishLoading repo: RewardedAdRepository, error: Error?) {
        if error == nil{
            print("Repo(\(repo.config.adUnitId)) is full, count:\(repo.adsRepo.count)")
        }else{
            print("Repo(\(repo.config.adUnitId)) have error:\(String(describing: error))")
        }
    }
    
    func nativeAdRepository(didReceive repo: NativeAdRepository) {
        if repo == RepositoryManager.shared.nativeAdRepo{
            loadedNativeAdCount = repo.adsRepo.count
        }
        if repo ==  RepositoryManager.shared.nativeVideoAdRepo{
            loadedVideoNativeAdCount = repo.adsRepo.count
        }
    }
}
extension MainController:InterstitialAdWrapperDelegate{
    func interstitialAdWrapper(didRemoveFromRepository ad: InterstitialAdWrapper) {
        loadedInterstinalAdCount = ad.owner?.adsRepo.count ?? 0
    }
}
extension MainController:RewardedAdWrapperDelegate{
    func rewardedAdWrapper(didRemoveFromRepository ad: RewardedAdWrapper) {
        loadedRewardedAdCount = ad.owner?.adsRepo.count ?? 0
    }
}
