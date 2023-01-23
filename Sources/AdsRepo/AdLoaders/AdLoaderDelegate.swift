//
//  AdLoaderDelegate.swift
//  AdsRepo
//
//  Created by Ali on 1/20/23.
//

import Foundation

public protocol AdLoaderDelegate:NSObject{
    func adLoader(_ adLoader:AdLoaderProtocol, didReceive ad:any AdWrapperProtocol)
    func adLoader(didFinishLoad adloader:AdLoaderProtocol,withError error:Error?)
}
