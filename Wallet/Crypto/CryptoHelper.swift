//
// Created by Daria Kokareva on 26/09/2019.
// Copyright (c) 2019 Enecuum. All rights reserved.
//

import CryptoSwift

class CryptoHelper {

    class func generateKeyPair() -> (privateKey: String, address: String) {
        let (privateKey, publicKey) = try! Secp256k1.keyPair()
        let compressedPublicKey = try! Secp256k1.compressPublicKey(publicKey)
        return (privateKey.toHexString(), compressedPublicKey.toHexString())
    }

    class func getPublicKey() -> String {
        let uintPrivateKey = Array(hex: AuthManager.key())
        let publicKey = try! Secp256k1.derivePublicKey(for: uintPrivateKey)
        let compressedPublicKey = try! Secp256k1.compressPublicKey(publicKey)
        return compressedPublicKey.toHexString()
    }

    class func isValidPrivateKey(_ key: String) -> Bool {
        let uintPrivateKey = Array(hex: key)
        return Secp256k1.isValidPrivateKey(uintPrivateKey)
    }

    class func isValidPublicKey(_ key: String) -> Bool {
        let uintPublicKey = Array(hex: key)
        return Secp256k1.isValidPublicKey(uintPublicKey)
    }

    class func buildTxHash(amount: String, random: String, from: String, to: String) -> String {
        return "\(amount.sha256())\(from.sha256())\(random.sha256())\(to.sha256())".sha256()
    }

    class func sign(_ message: String) -> String {
        let messageData = message.data(using: .ascii)!
        let mshHash = messageData.sha256().toHexString()
        let msg = Data(hex: mshHash)
        let uintPrivateKey = Array(hex: AuthManager.key())
        let sig = try! Secp256k1.sign(msg: msg.bytes, with: uintPrivateKey, nonceFunction: .default)
        return sig.toHexString()
    }

    class func verify(message: String, sign: String) -> Bool {
        let messageData = message.data(using: .ascii)!
        let mshHash = messageData.sha256().toHexString()
        let msg = Data(hex: mshHash)

        let signData = Data(hex: sign)
        let uintPrivateKey = Array(hex: AuthManager.key())
        let pub = try! Secp256k1.derivePublicKey(for: uintPrivateKey)
        return Secp256k1.verify(msg: msg.bytes, sig: signData.bytes, pubkey: pub)
    }
}