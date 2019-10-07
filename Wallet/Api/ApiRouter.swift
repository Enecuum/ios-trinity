//
// Created by Daria Kokareva on 26/09/2019.
// Copyright (c) 2019 Enecuum. All rights reserved.
//

import Alamofire

enum ApiRouter {
    case balance
    case transaction

    // MARK: - Base url

    static var baseIp: String {
        if let customIp = Defaults.baseIP() {
            return customIp
        }
        #if DEBUG
        return ApiConstants.DevServer.baseIP
        #endif
        return ApiConstants.ProdServer.baseIP
    }

    private var apiUrl: URL {
        return try! "http://\(ApiRouter.baseIp):80/api/v1/".asURL()
    }

    // MARK: - HTTPMethod

    private var method: HTTPMethod {
        switch self {
        case .balance:
            return .get
        case .transaction:
            return .post
        }
    }

    // MARK: - Path

    private var path: String {
        switch self {
        case .balance:
            return "balance"
        case .transaction:
            return "tx"
        }
    }

    // MARK: - Request

    func requestUrl() -> URL {
        return apiUrl.appendingPathComponent(path)
    }
}
