//
//  AdLoaderProtocol.swift
//  AdsRepo
//
//  Created by Ali on 1/20/23.
//

import Foundation
protocol AdLoaderProtocol {

    var state:AdLoaderState{get}
    var config:RepositoryConfig{get}
    var delegate:AdLoaderDelegate?{get set}
    func load(adCount:Int)

}
