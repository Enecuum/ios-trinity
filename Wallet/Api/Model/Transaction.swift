//
// Created by Daria Kokareva on 27/09/2019.
// Copyright (c) 2019 Enecuum. All rights reserved.
//

struct Transaction: Codable {
    let amount: String
    let from: String
    let nonce: UInt32
    let sign: String
    let to: String
    let data: String
    let ticker: String
}