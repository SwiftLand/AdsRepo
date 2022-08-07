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
        if (indexPath.item%9 == 0){
            switch type{
            case .banner:
                let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "BannerNativeAdCell", for: indexPath) as! BannerNativeAdCell
                if let adRepository = adRepository{
                    cell.adRepository = adRepository
                }
                return cell
            case .largeBanner:
                let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "NativeAdCell", for: indexPath) as! NativeAdCell
                
                cell.mediaViewWidthConstrians.constant = collectionView.bounds.width-16//<-margins
                
                if let adRepository = adRepository{
                    cell.adRepository = adRepository
                }
                return cell
            }
        }else{
            let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "SimpleCell", for: indexPath)
            let title = UILabel(frame: CGRect(x: 0, y: 25, width: cell.bounds.size.width, height: 50))
            title.text = "item (\(indexPath.row))"
            title.font = .systemFont(ofSize: 22)
            title.textAlignment = .center
            cell.contentView.subviews.forEach({$0.removeFromSuperview()})
            cell.contentView.addSubview(title)
            return cell
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        switch cell {
        case let adCell as BannerNativeAdCell:
            adCell.showNativeAdIfNeed()
        case let adCell as NativeAdCell:
            adCell.showNativeAdIfNeed()
        default:break
        }
        
    }
    override func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        switch cell {
        case let adCell as BannerNativeAdCell:
            adCell.deregisterCellForAdsRepo()
        case let adCell as NativeAdCell:
            adCell.deregisterCellForAdsRepo()
        default:break
            
        }
    }
}

extension CollectionViewNativeAdVC:UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if (indexPath.item%9 == 0){
            if type == .banner {
                return CGSize(width:collectionView.bounds.width, height: 200)
            }else if type == .largeBanner{
                return CGSize(width:collectionView.bounds.width, height: 400)
            }
        }
        return CGSize(width:collectionView.bounds.width*0.44, height: 100)
        
    }
}
