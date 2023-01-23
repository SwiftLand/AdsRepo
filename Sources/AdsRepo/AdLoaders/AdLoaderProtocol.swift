//
//  AdLoaderProtocol.swift
//  AdsRepo
//
//  Created by Ali on 1/20/23.
//

import Foundation
import GoogleMobileAds

public protocol AdLoaderProtocol {
    var request:GADRequest{get set}
    var state:AdLoaderState{get}
    var config:AdRepositoryConfig{get}
    var delegate:AdLoaderDelegate?{get set}
    init(config:AdRepositoryConfig)
    func load(count:Int)
}
