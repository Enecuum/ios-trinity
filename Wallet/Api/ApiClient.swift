//
// Created by Daria Kokareva on 27/09/2019.
// Copyright (c) 2019 Enecuum. All rights reserved.
//

import Alamofire

class ApiClient {

    static func balance(id: String, completion: @escaping (AFResult<BalanceAmount>) -> Void) {
        let params = [ApiConstants.APIParameterKey.id: id]
        AF.request(ApiRouter.balance.requestUrl(),
                   method: .get,
                   parameters: params).validate().responseDecodable { (response: AFDataResponse<BalanceAmount>) in
            completion(response.result)
        }
    }

    static func transaction(_ transaction: Transaction, completion: @escaping (AFResult<TransactionStatus>) -> Void) {
        let transactionsList = [transaction]
        AF.request(ApiRouter.transaction.requestUrl(),
                   method: .post,
                   parameters: transactionsList,
                   encoder: JSONParameterEncoder.default).validate().responseDecodable { (response: AFDataResponse<TransactionStatus>) in
            completion(response.result)
        }
    }

    static func stats(completion: @escaping (AFResult<Statistics>) -> Void) {
        AF.request(ApiRouter.stats.requestUrl(),
                   method: .get).validate().responseDecodable { (response: AFDataResponse<Statistics>) in
            completion(response.result)
        }
    }

    static func blocks(completion: @escaping (AFResult<BlockAmount>) -> Void) {
        AF.request(ApiRouter.blocks.requestUrl(),
                   method: .get).validate().responseDecodable { (response: AFDataResponse<BlockAmount>) in
            completion(response.result)
        }
    }

    static func referrerStake(completion: @escaping (AFResult<ReferrerStake>) -> Void) {
        AF.request(ApiRouter.referrerStake.requestUrl(),
                   method: .get).validate().responseDecodable { (response: AFDataResponse<ReferrerStake>) in
            completion(response.result)
        }
    }

    static func roiList(completion: @escaping (AFResult<[Roi]>) -> Void) {
        AF.request(ApiRouter.roi.requestUrl(),
                   method: .get).validate().responseDecodable { (response: AFDataResponse<[Roi]>) in
            completion(response.result)
        }
    }
}