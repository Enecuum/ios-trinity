//
// Created by Daria Kokareva on 05/10/2019.
// Copyright (c) 2019 Enecuum. All rights reserved.
//

import Foundation

class Defaults {

    struct Constants {
        static let runOnceKey: String = "runOnceKey"
        static let balanceKey: String = "balanceKey"
        static let baseIP: String = "baseIp"
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
        return UserDefaults.standard.bool(forKey: Constants.runOnceKey)
    }

    static func setBaseIP(_ ip: String) {
        UserDefaults.standard.set(ip, forKey: Constants.baseIP)
    }

    static func baseIP() -> String? {
        return UserDefaults.standard.string(forKey: Constants.baseIP)
    }

    static func clearUserData() {
        if let domain = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: domain)
            UserDefaults.standard.synchronize()
        }
        Defaults.setRunOnceFlag()
    }
}
