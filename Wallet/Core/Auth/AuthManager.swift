//
// Created by Daria Kokareva on 26/09/2019.
// Copyright (c) 2019 Enecuum. All rights reserved.
//

class AuthManager {

    class func signIn(_ key: String) {
        try! KeychainPasswordItem(service: Constants.serviceName, account: Constants.accountName).savePassword(key)
    }

    class func isSignedIn() -> Bool {
        do {
            let password = try KeychainPasswordItem(service: Constants.serviceName,
                                                    account: Constants.accountName).readPassword()
            return !password.isEmpty
        } catch {
            print("Failed to retrieve account info")
        }
        return false
    }

    struct Constants {
        static let serviceName: String = "EnecuumWalletAuthService"
        static let accountName: String = "login"
    }
}
