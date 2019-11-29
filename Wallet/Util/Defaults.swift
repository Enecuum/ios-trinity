//
// Created by Daria Kokareva on 05/10/2019.
// Copyright (c) 2019 Enecuum. All rights reserved.
//

import Foundation

class Defaults {

    struct Constants {
        static let runOnceKey: String = "runOnceKey"
        static let balanceKey: String = "balanceKey"
        static let baseIP: String = "baseIP"
        static let languageCode: String = "languageCode"
        static let usdRateKey: String = "usdRateKey"
        static let minStakeKey: String = "minStakeKey"
        static let maxStakeKey: String = "maxStakeKey"
    }

    static func saveBalance(_ balance: NSDecimalNumber) {
        UserDefaults.standard.set("\(balance)", forKey: Constants.balanceKey)
    }

    static func getBalance() -> NSDecimalNumber? {
        if let stringValue = UserDefaults.standard.value(forKey: Constants.balanceKey) as? String {
            return NSDecimalNumber(string: stringValue)
        }
        return nil
    }

    static func setRunOnceFlag() {
        UserDefaults.standard.set(true, forKey: Constants.runOnceKey)
    }

    static func isRunOnce() -> Bool {
        UserDefaults.standard.bool(forKey: Constants.runOnceKey)
    }

    static func setBaseIP(_ ip: String) {
        UserDefaults.standard.set(ip, forKey: Constants.baseIP)
    }

    static func baseIP() -> String? {
        UserDefaults.standard.string(forKey: Constants.baseIP)
    }

    static func setLanguageCode(_ code: String) {
        UserDefaults.standard.set(code, forKey: Constants.languageCode)
    }

    static func languageCode() -> String? {
        UserDefaults.standard.string(forKey: Constants.languageCode)
    }

    static func setUsdRate(_ usdRate: String) {
        UserDefaults.standard.set(usdRate, forKey: Constants.usdRateKey)
    }

    static func usdRate() -> String? {
        UserDefaults.standard.string(forKey: Constants.usdRateKey)
    }

    static func setMinStake(_ minStake: Float) {
        UserDefaults.standard.set(minStake, forKey: Constants.minStakeKey)
    }

    static func minStake() -> Float? {
        UserDefaults.standard.float(forKey: Constants.minStakeKey)
    }

    static func setMaxStake(_ maxStake: Float) {
        UserDefaults.standard.set(maxStake, forKey: Constants.maxStakeKey)
    }

    static func maxStake() -> Float? {
        UserDefaults.standard.float(forKey: Constants.maxStakeKey)
    }

    static func clearUserData() {
        let langCode = languageCode()
        if let domain = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: domain)
            UserDefaults.standard.synchronize()
        }
        Defaults.setRunOnceFlag()
        if let code = langCode {
            Defaults.setLanguageCode(code)
        }
    }
}
