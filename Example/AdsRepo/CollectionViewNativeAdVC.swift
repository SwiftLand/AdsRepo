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
    
    typealias RepoTpye = NativeAdRepository
    weak var adRepository:RepoTpye? = nil
    var type:AdType = .banner
    
    override func viewWillAppear(_ animated: Bool) {
        self.collectionView?.register(UINib(nibName: "BannerNativeAdCell", bundle: nil), forCellWithReuseIdentifier: "BannerNativeAdCell")
        self.collectionView?.register(UINib(nibName: "NativeAdCell", bundle: nil), forCellWithReuseIdentifier: "NativeAdCell")
        adRepository?.append(delegate: self)

    }
    override func viewWillDisappear(_ animated: Bool) {
        adRepository?.remove(delegate: self)
    }
}

extension CollectionViewNativeAdVC{
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 100
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section%2 == 0 ? 1 : 10
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (indexPath.section%2 == 0){
            switch type{
            case .banner:
                return collectionView.dequeueReusableCell(withReuseIdentifier: "BannerNativeAdCell", for: indexPath) as! BannerNativeAdCell
            case .largeBanner:
                return collectionView.dequeueReusableCell(withReuseIdentifier: "NativeAdCell", for: indexPath) as! NativeAdCell
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
            adRepository?.loadAd {adWrapper in
                adCell.adWrapper = adWrapper
            }
        case let adCell as NativeAdCell:
            adRepository?.loadAd {adWrapper in
                adCell.adWrapper = adWrapper
            }
        default:break
        }
        
    }
}

extension CollectionViewNativeAdVC:UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if (indexPath.section%2 == 0){
            if type == .banner {
                return CGSize(width:collectionView.bounds.width, height: 200)
            }else if type == .largeBanner{
                return CGSize(width:collectionView.bounds.width, height: 400)
            }
        }
        return CGSize(width:collectionView.bounds.width*0.44, height: 100)
        
    }
}

extension CollectionViewNativeAdVC:AdRepositoryDelegate{
   
 
    func adRepository(didFinishLoading repository:AnyRepositoryType, error: Error?) {

        if let error = error {
            print("❗️","have error in loading",error)
            return
        }

        guard let adRepository = self.adRepository else {return}

        collectionView?.visibleCells.forEach{
            cell in
            if let adCell = cell as? NativeAdCell,
               adCell.adWrapper == nil {
                adRepository.loadAd {adWrapper in
                    adCell.adWrapper = adWrapper
                }
            }
            if let adCell = cell as? BannerNativeAdCell,
                adCell.adWrapper == nil {
                adRepository.loadAd {adWrapper in
                    adCell.adWrapper = adWrapper
                }
            }
        }
    }

    func adRepository(didExpire ad:AnyAdType, in repository:AnyRepositoryType) {
        collectionView?.visibleCells.forEach{
            cell in
            
            if let adCell = cell as? NativeAdCell,adCell.adWrapper === ad{
                adCell.showCountLabel.text = "(expired)"
            }
            if let adCell = cell as? BannerNativeAdCell,adCell.adWrapper === ad{
                adCell.showCountLabel.text = "(expired)"
            }
        }
    }
}
