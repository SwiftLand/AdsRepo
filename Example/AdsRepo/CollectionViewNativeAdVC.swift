//
//  CollectionViewVC.swift
//  AdsRepo_Example
//
//  Created by Ali on 7/23/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import AdsRepo

class CollectionViewNativeAdVC:UICollectionViewController{
    enum AdType{
        case banner
        case largeBanner
    }
    weak var adRepository:NativeAdsRepository? = nil
    var type:AdType = .banner
    var itemCount = 0
    override func viewWillAppear(_ animated: Bool) {
        self.collectionView?.register(UINib(nibName: "BannerNativeAdCell", bundle: nil), forCellWithReuseIdentifier: "BannerNativeAdCell")
        self.collectionView?.register(UINib(nibName: "NativeAdCell", bundle: nil), forCellWithReuseIdentifier: "NativeAdCell")
        itemCount = 1000
        collectionView?.reloadData()
        collectionView?.layoutIfNeeded()
    }
}

extension CollectionViewNativeAdVC{
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemCount
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (indexPath.item%5 == 0){
            switch type{
            case .banner:
                let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "BannerNativeAdCell", for: indexPath) as! BannerNativeAdCell
                if let adRepository = adRepository {
                    cell.showNativeAd(adRepository)
                }
                return cell
            case .largeBanner:
                let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "NativeAdCell", for: indexPath) as! NativeAdCell
                if let adRepository = adRepository {
                    cell.showNativeAd(adRepository)
                }
                return cell
            }
        }else{
            let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "SimpleCell", for: indexPath)
            let title = UILabel(frame: CGRect(x: 0, y: 25, width: cell.bounds.size.width, height: 50))
            title.text = "raw (\(indexPath.row))"
            title.font = .systemFont(ofSize: 22)
            title.textAlignment = .center
            cell.contentView.subviews.forEach({$0.removeFromSuperview()})
            cell.contentView.addSubview(title)
            return cell
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let adCell = cell as? BannerNativeAdCell else {return}
        adCell.registerCellForAdsRepo()
        
    }
    override func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let adCell = cell as? BannerNativeAdCell else {return}
        adCell.deregisterCellForAdsRepo()
    }
}
extension CollectionViewNativeAdVC:UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cell = collectionView.cellForItem(at: indexPath)
        
        if cell is BannerNativeAdCell {
            return CGSize(width: collectionView.bounds.width, height: 200)
        }
        if cell is NativeAdCell {
            return  CGSize(width: collectionView.bounds.width, height: 400)
        }
        
        return CGSize(width: collectionView.bounds.width, height: 100)
      
    }
}
