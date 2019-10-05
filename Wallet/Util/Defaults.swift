//
// Created by Daria Kokareva on 05/10/2019.
// Copyright (c) 2019 Enecuum. All rights reserved.
//

import Foundation

class Defaults {

    struct Constants {
        static let balanceKey: String = "balanceKey"
    }

    static func saveBalance(_ balance: Decimal) {
        UserDefaults.standard.set("\(balance)", forKey: Constants.balanceKey)
    }

    static func getBalance() -> Decimal? {
        if let stringValue = UserDefaults.standard.value(forKey: Constants.balanceKey) as? String {
            return Decimal(string: stringValue)
        }
        return nil
    }

    static func clearUserData() {
        if let domain = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: domain)
            UserDefaults.standard.synchronize()
        }
    }
}
