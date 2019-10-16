//
// Created by Daria Kokareva on 16.10.2019.
// Copyright (c) 2019 Enecuum. All rights reserved.
//

struct Statistics: Codable {
    let accounts: Int
    let csup: UInt64
    let reward_poa: UInt64
    let reward_pow: UInt64
    let pos_count: Int?
    let pow_count: Int?
    let poa_count: Int?
    let tps: Int?
    let max_tps: Int?

    /*
     let hashrate: String?
     let cg_usd: UInt64*/
}