//
// Created by Daria Kokareva on 26/09/2019.
// Copyright (c) 2019 Enecuum. All rights reserved.
//

import Alamofire

enum ApiRouter {
    case balance(id: String)

    // MARK: - HTTPMethod

    private var method: HTTPMethod {
        switch self {
        case .balance:
            return .get
        }
    }

    // MARK: - Path

    private var path: String {
        switch self {
        case .balance:
            return "balance"
        }
    }

    // MARK: - Parameters

    private var parameters: Parameters? {
        switch self {
        case .balance(let id):
            return [ApiConstants.APIParameterKey.id: id]
        }
    }

    // MARK: - Request

   /* func asURLRequest() throws -> URLRequest {
        //TODO: switch
        let url = try ApiConstants.DevServer.baseURL.asURL()

        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        // Common Headers
        urlRequest.setValue(ApiConstants.ContentType.json.rawValue,
                            forHTTPHeaderField: ApiConstants.HTTPHeaderField.acceptType.rawValue)
        urlRequest.setValue(ApiConstants.ContentType.json.rawValue,
                            forHTTPHeaderField: ApiConstants.HTTPHeaderField.contentType.rawValue)

        // Parameters
        if let parameters = parameters {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            } catch {
                throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
            }
        }

        return urlRequest
    }*/

    func asDataRequest() throws -> DataRequest {
        //TODO: switch
        let url = try ApiConstants.DevServer.baseURL.asURL()
        let requestUrl = url.appendingPathComponent(path)

        switch method {
        case .get:
            return AF.request(requestUrl, parameters: parameters)
        default:
            fatalError("Not implemented yet")
        }
    }
}
