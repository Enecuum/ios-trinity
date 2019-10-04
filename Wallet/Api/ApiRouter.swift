//
// Created by Daria Kokareva on 26/09/2019.
// Copyright (c) 2019 Enecuum. All rights reserved.
//

import Alamofire

enum ApiRouter {
    case balance(id: String)
    case transaction(transactions: [Transaction])

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

    // MARK: - Parameters

    private var parameters: Parameters? {
        switch self {
        case .balance(let id):
            return [ApiConstants.APIParameterKey.id: id]
        case .transaction(let transactions):
            //return transactions
                return nil
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
        case .post:
            return AF.request(requestUrl, method: .post, parameters: parameters)
        default:
            fatalError("Not implemented yet")
        }
    }
}
