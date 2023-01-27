//
//  DateEx.swift
//  AdsRepo-Unit-Tests
//
//  Created by Ali on 1/27/23.
//

import Foundation


internal var __date_currentImpl: () -> Date = {
    return Date()
}

extension Date {
    /// Return current date.
    /// Please replace `Date()` and `Date(timeIntervalSinceNow:)` with `Date.current`,
    /// the former will be prohibited by lint rules/commit hook.
    static var current: Date {
        return __date_currentImpl()
    }
}
