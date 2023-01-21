//
//  AdLoaderDelegate.swift
//  AdsRepo
//
//  Created by Ali on 1/20/23.
//

import Foundation

protocol AdLoaderDelegate:NSObject{
    func adLoader(_ adLoader:AdLoaderProtocol, didRecive ad:any AdWrapperProtocol )
    func adLoader(didFinishLoad adloader:AdLoaderProtocol,withError error:Error?)
}
