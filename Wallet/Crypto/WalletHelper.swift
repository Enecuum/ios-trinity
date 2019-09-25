//
// Created by Daria Kokareva on 26/09/2019.
// Copyright (c) 2019 Enecuum. All rights reserved.
//

class WalletHelper {

    class func newWallet() -> (privateKey: String, address: String) {
        let (privateKey, publicKey) = try! Secp256k1.keyPair()
        let compressedPublicKey = try! Secp256k1.compressPublicKey(publicKey)

//        let msg = Array("hello world".utf8)
//      let sig = try! Secp256k1.sign(msg: msg, with: privkey, nonceFunction: .default)
//        let result2 = Secp256k1.verify(msg: msg, sig: sig, pubkey: pubkey)

        return (privateKey.toHexString(), compressedPublicKey.toHexString())
    }
}
