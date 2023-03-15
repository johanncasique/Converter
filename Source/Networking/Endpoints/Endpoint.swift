//
//  Endpoint.swift
//  Converter (iOS)
//
//  Created by johann casique on 7/12/22.
//

import Foundation

public protocol NetworkErrorLogger {
    func log(request: URLRequest)
    func log(responseData data: Data?, response: URLResponse?)
    func log(error: Error)
}

protocol Endpoint {
    var baseURL: URL { get }
    var path: String { get }
    var method: HttpMethod { get }
    var headers: [String: String]? { get }
    var parameters: [URLQueryItem]? { get }
}

enum HttpMethod: String {
    case get = "GET"
}

