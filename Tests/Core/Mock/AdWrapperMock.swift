//
//  AdWrapperMock.swift
//  AdsRepo-Unit-Tests
//
//  Created by Ali on 2/3/23.
//

import Foundation
@testable import AdsRepo


class AdWrapperMock: NSObject,AdWrapperProtocol {

    var config: AdRepositoryConfig
    var uniqueId: String = UUID().uuidString
    var loadedAd: AdMock
    var loadedDate: Date = Date()
    var showCount: Int = 0


    init(loadedAd: AdMock, config: AdRepositoryConfig) {
        self.loadedAd = loadedAd
        self.config = config
    }
}
