//
//  ExchangeRateEndpoint.swift
//  Converter (iOS)
//
//  Created by johann casique on 15/3/23.
//

import Foundation

struct ExchangeRateEndpoint: Endpoint {
    let currency: String

    var baseURL: URL {
        return APIConfig.baseURL
    }

    var path: String {
        return "/\(APIConfig.apiKey)/latest/\(currency)"
    }

    var method: HttpMethod {
        return .get
    }

    var headers: [String: String]? {
        return nil
    }

    var parameters: [URLQueryItem]? {
        return nil
    }
}
