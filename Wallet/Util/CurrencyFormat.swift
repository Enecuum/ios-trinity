//
// Created by Daria Kokareva on 25.11.2019.
// Copyright (c) 2019 Enecuum. All rights reserved.
//

import Foundation

class CurrencyFormat {

    struct Constants {
        static let currency: String = "ENQ"
    }

    static func asUsdString(_ value: NSDecimalNumber) -> String {
        let formattedValue = Formatter.decimalString(value, fractionDigits: 5)
        return R.string.untranslatable.enq_as_usd(Constants.currency, formattedValue)
    }

    static func referralBuyMessage(_ value: NSDecimalNumber) -> String {
        let formattedValue = Formatter.decimalString(value, fractionDigits: 5)
        let format = R.string.localizable.referral_buy_message.localized()
        return String(format: format, formattedValue, Constants.currency, Constants.currency)
    }

    static func buyCurrencyString() -> String {
        let format = R.string.localizable.buy_enq.localized()
        return String(format: format, Constants.currency)
    }

    static func referralMessage() -> String {
        let format = R.string.localizable.referral_message.localized()
        return String(format: format, Constants.currency)
    }

    static func currencyAddressString() -> String {
        let format = R.string.localizable.enq_address_to_send.localized()
        return String(format: format, Constants.currency)
    }

    static func buyNativeCoinString() -> String {
        let format = R.string.localizable.buy_native_title_link.localized()
        return String(format: format, Constants.currency)
    }

    static func coinToBtcString() -> String {
        R.string.untranslatable.coin_to_btc(Constants.currency)
    }

    static func coinToUsdString() -> String {
        R.string.untranslatable.coin_to_usd(Constants.currency)
    }

    static func coinToUsdtString() -> String {
        R.string.untranslatable.coin_to_usdt(Constants.currency)
    }

    static func coinToEthString() -> String {
        R.string.untranslatable.coin_to_eth(Constants.currency)
    }

    static func coinToRubString() -> String {
        R.string.untranslatable.coin_to_rub(Constants.currency)
    }

    static func welcomeCurrencyString() -> String {
        let format = R.string.localizable.welcome_to_enq.localized()
        return String(format: format, Constants.currency)
    }

   static func valueString(_ value: String) -> String {
        R.string.untranslatable.enq_value(value, Constants.currency)
    }
}