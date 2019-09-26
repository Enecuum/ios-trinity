//
// Created by Daria Kokareva on 27/09/2019.
// Copyright (c) 2019 Enecuum. All rights reserved.
//

import Alamofire

class ApiClient {

    static func balance(id: String, completion: @escaping (AFResult<BalanceAmount>) -> Void) {
        try! ApiRouter.balance(id: id).asDataRequest().validate().responseDecodable { (response: AFDataResponse<BalanceAmount>) in
            completion(response.result)
        }
    }
}