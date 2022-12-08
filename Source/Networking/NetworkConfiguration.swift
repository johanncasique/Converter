//
//  NetworkConfiguration.swift
//  Converter (iOS)
//
//  Created by johann casique on 7/12/22.
//

import Foundation

public protocol NetworkConfigurable {
    var baseURL: URL { get }
    var headers: [String: String] { get }
    var queryParameters: [URLQueryItem] { get }
    var logger: NetworkErrorLogger { get }
}

public struct ApiDataNetworkConfig: NetworkConfigurable {
    public let baseURL: URL
    public let headers: [String: String]
    public let queryParameters: [URLQueryItem]
    public var logger: NetworkErrorLogger
    
    public init(
        baseURL: URL,
        headers: [String: String] = [:],
        queryParameters: [URLQueryItem] = [],
        logger: NetworkErrorLogger = DefaultNetworkErrorLogger()
    ) {
        self.baseURL = baseURL
        self.headers = headers
        self.queryParameters = queryParameters
        self.logger = logger
    }
}
