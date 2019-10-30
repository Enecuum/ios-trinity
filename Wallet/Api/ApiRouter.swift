//
// Created by Daria Kokareva on 26/09/2019.
// Copyright (c) 2019 Enecuum. All rights reserved.
//

import Alamofire

enum ApiRouter {
    case balance
    case transaction
    case stats
    case blocks

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

    static var baseDomain: String {
        #if DEBUG
        return ApiConstants.DevServer.baseDomain
        #endif
        return ApiConstants.ProdServer.baseDomain
    }

    private var apiUrl: URL {
        try! "http://\(ApiRouter.baseIp):80/api/v1/".asURL()
    }

    // MARK: - HTTPMethod

    private var method: HTTPMethod {
        switch self {
        case .balance:
            return .get
        case .transaction:
            return .post
        case .stats:
            return .get
        case .blocks:
            return .get
        }
    }

    // MARK: - Path

    private var path: String {
        switch self {
        case .balance:
            return "balance"
        case .transaction:
            return "tx"
        case .stats:
            return "stats"
        case .blocks:
            return "height"
        }
    }

    // MARK: - Request

    func requestUrl() -> URL {
        apiUrl.appendingPathComponent(path)
    }
}
