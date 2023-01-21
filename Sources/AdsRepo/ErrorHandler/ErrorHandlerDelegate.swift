//
//  ErrorHandlerDelegate.swift
//  AdsRepo
//
//  Created by Ali on 1/21/23.
//

import Foundation
protocol ErrorHandlerDelegate:NSObject{
    func errorHandler(onRetry count:Int, for error:Error?)
}
