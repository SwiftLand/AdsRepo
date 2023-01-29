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
import GoogleMobileAds
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
    
    
    override func viewWillAppear(_ animated: Bool) {
        RepositoryManager.shared.add(Observer: self)
        interstinalAdBtn.setTitle("Interstinal Ad (loaded:\(loadedInterstinalAdCount))", for: .normal)
        rewardedAdBtn.setTitle("Rewarded Ad (loaded:\(loadedRewardedAdCount))", for: .normal)
        
        nativeBannerCollectionViewBtn.setTitle("Native banner ad in collection view (loaded:\(loadedNativeAdCount))", for: .normal)
        nativeCollectionViewBtn.setTitle("Native ad in collection view (loaded:\(loadedNativeAdCount))", for: .normal)
        imageNativeAdbtn.setTitle("Full screen Image Native ad (loaded:\(loadedNativeAdCount))", for: .normal)
        
        VideoNativeAdBtn.setTitle("Full screen Video Native ad (loaded:\(loadedVideoNativeAdCount))", for: .normal)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        RepositoryManager.shared.remove(Observer: self)
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
            guard let adWrapper =  RepositoryManager.shared.rewardedAdsRepo.loadAd() else {return}
            adWrapper.loadedAd.present(fromRootViewController: self, userDidEarnRewardHandler: {
                [weak self] in
                self?.onReceivedReward (ad:adWrapper.loadedAd)
            })
        case interstinalAdBtn:
            guard let adWrapper =  RepositoryManager.shared.interstitialAdsRepo.loadAd() else {return}
            adWrapper.loadedAd.present(fromRootViewController: self)
        default:break
        }
    }
    
    private func onReceivedReward (ad:GADRewardedAd){
        guard ad.adReward.amount != 0 else {
            return
        }
        let amount = ad.adReward.amount
        print("Rewarded received with amount \(amount).")
    }
}
extension MainController:AdRepositoryDelegate{
    
    func adRepository(didReceive repository: AnyRepositoryType) {
        updateRepositoryCountView(repository)
    }
    
    func adRepository(didFinishLoading repository:AnyRepositoryType,error:Error?){
        if error == nil{
            print("Repo(\(repository.config.adUnitId)) is full, count:\(repository.currentAdCount)")
        }else{
            print("Repo(\(repository.config.adUnitId)) have error:\(String(describing: error))")
        }
    }
    
    func adRepository(didExpire ad:AnyAdType,in repository:AnyRepositoryType){
        updateRepositoryCountView(repository)
    }
    
    func adRepository(didRemove ad:AnyAdType,in repository:AnyRepositoryType){
        updateRepositoryCountView(repository)
    }
    
    private func updateRepositoryCountView(_ repository:any AdRepositoryProtocol){
        switch repository.self{
        case RepositoryManager.shared.interstitialAdsRepo:
            loadedInterstinalAdCount = repository.currentAdCount
        case RepositoryManager.shared.rewardedAdsRepo:
            loadedRewardedAdCount = repository.currentAdCount
        case RepositoryManager.shared.nativeAdRepo:
            loadedNativeAdCount = repository.currentAdCount
        case RepositoryManager.shared.nativeVideoAdRepo:
            loadedVideoNativeAdCount = repository.currentAdCount
        default:break
        }
    }
}

