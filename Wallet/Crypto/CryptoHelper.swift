//
// Created by Daria Kokareva on 26/09/2019.
// Copyright (c) 2019 Enecuum. All rights reserved.
//

class CryptoHelper {

    class func generateKeyPair() -> (privateKey: String, address: String) {
        let (privateKey, publicKey) = try! Secp256k1.keyPair()
        let compressedPublicKey = try! Secp256k1.compressPublicKey(publicKey)
        return (privateKey.toHexString(), compressedPublicKey.toHexString())
    }

    class func isValidPrivateKey(_ key: String) -> Bool {
        let uintPrivateKey = Array(hex: key)
        return Secp256k1.isValidPrivateKey(uintPrivateKey)
    }

    class func getAddress() -> String {
        let uintPrivateKey = Array(hex: AuthManager.key())
        let publicKey = try! Secp256k1.derivePublicKey(for: uintPrivateKey)
        let compressedPublicKey = try! Secp256k1.compressPublicKey(publicKey)
        return compressedPublicKey.toHexString()
    }
}
