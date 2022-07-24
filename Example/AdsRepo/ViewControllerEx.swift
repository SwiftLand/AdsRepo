//
//  ViewControllerEx.swift
//  AdsRepo_Example
//
//  Created by Ali on 7/23/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
extension UIViewController{
    
    static func instantiate() -> Self {
           let storyboardIdentifier = String(describing: self)
           // `Main` can be your stroyboard name.
           let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
           
           guard let vc = storyboard.instantiateViewController(withIdentifier: storyboardIdentifier) as? Self else {
               fatalError("No storyboard with this identifier ")
           }
           return vc
    }
}
