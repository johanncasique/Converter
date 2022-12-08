//
//  Endpoint.swift
//  Converter (iOS)
//
//  Created by johann casique on 7/12/22.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidaServerResponse
    case invalidaServerResponseStatusCode
    case decodingError
}

public protocol NetworkErrorLogger {
    func log(request: URLRequest)
    func log(responseData data: Data?, response: URLResponse?)
    func log(error: Error)
}

enum HTTPMethod {
    case get
    case post(Data?)
    case delete
    
    var name: String {
        switch self {
        case .get: return "GET"
        case .post: return "POST"
        case .delete: return "DELETE"
        }
    }
}

struct Endpoint<R: Codable> {
    let path: String
    var method: HTTPMethod = .get
}

