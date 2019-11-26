//
// Created by Daria Kokareva on 25.11.2019.
// Copyright (c) 2019 Enecuum. All rights reserved.
//

import Foundation

class Formatter {

    static func decimalString(_ decimal: NSDecimalNumber, fractionDigits: Int = 6, decimalSeparator: String = ".") -> String {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = fractionDigits
        formatter.decimalSeparator = decimalSeparator
        return formatter.string(from: decimal) ?? "0"
    }

}