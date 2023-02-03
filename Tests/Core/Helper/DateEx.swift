//
//  DateEx.swift
//  AdsRepo-Unit-Tests
//
//  Created by Ali on 1/27/23.
//

import Foundation
@testable import AdsRepo
extension Date {
    static func overrideCurrentDate(_ currentDate: @autoclosure @escaping () -> Date) {
      __date_currentImpl = currentDate
    }
}
