//
// Created by Daria Kokareva on 26/09/2019.
// Copyright (c) 2019 Enecuum. All rights reserved.
//

struct ApiConstants {
    struct ProdServer {
        static let baseURL = "http://95.216.68.221:80/api/v1/"
    }

    struct DevServer {
        static let baseURL = "http://95.217.0.123:80/api/v1/"
    }

    struct APIParameterKey {
        static let id = "id"
        static let amount = "amount"
        static let from = "from"
        static let to = "to"
        static let nonce = "nonce"
        static let sign = "sign"
    }

    enum HTTPHeaderField: String {
        case authentication = "Authorization"
        case contentType = "Content-Type"
        case acceptType = "Accept"
        case acceptEncoding = "Accept-Encoding"
    }

    enum ContentType: String {
        case json = "application/json"
    }
}