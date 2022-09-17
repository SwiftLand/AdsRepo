//
//  WeakContainer.swift
//  AdsRepo
//
//  Created by Ali on 9/17/22.
//

import Foundation
struct Weak<T> {
    var value: T? { provider() }
    private let provider: () -> T?

    init(_ object: T) {
        // Any Swift value can be "promoted" to an AnyObject, however,
        // that doesn't automatically turn it into a reference.
        let reference = object as AnyObject

        provider = { [weak reference] in
            reference as? T
        }
    }
}
