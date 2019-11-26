//
// Created by Daria Kokareva on 25.11.2019.
// Copyright (c) 2019 Enecuum. All rights reserved.
//

import Foundation

class CurrencyFormat {

    static func asUsdString(_ value: NSDecimalNumber) -> String {
        let formattedValue = Formatter.decimalString(value, fractionDigits: 5)
        return R.string.untranslatable.enq_as_usd(formattedValue)
    }

}