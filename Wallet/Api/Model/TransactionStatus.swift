//
// Created by Daria Kokareva on 27/09/2019.
// Copyright (c) 2019 Enecuum. All rights reserved.
//

struct TransactionStatus: Codable {
    struct Result: Codable {
        let hash: String
        let status: Int
    }

    let err: Int
    let result: [Result]
}