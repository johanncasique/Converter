//
//  APIError.swift
//  Converter (iOS)
//
//  Created by johann casique on 15/3/23.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case requestFailed
    case serverError(statusCode: Int)
    case dataMissing
    case decodingError(Error)
}
