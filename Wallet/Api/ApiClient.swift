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
}