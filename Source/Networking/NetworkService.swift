//
//  Service.swift
//  Converter (iOS)
//
//  Created by johann casique on 27/9/21.
//

import Foundation

protocol NetworkService {
    func request<R: Codable>(_ endpoint: Endpoint<R>, configure: NetworkConfigurable) async throws -> R
}

class HTTPClient: NetworkService {
    func request<R>(_ endpoint: Endpoint<R>, configure: NetworkConfigurable) async throws -> R {
        print(endpoint.path)
        let path = configure.baseURL.appending(path: endpoint.path)
        var request = URLRequest(url: path)

        switch endpoint.method {
        case .get:
            var components = URLComponents(url: path, resolvingAgainstBaseURL: true)
            components?.queryItems = configure.queryParameters
            guard let url = components?.url else {
                throw NetworkError.invalidURL
            }
            request = URLRequest(url: url)
        case .post(let data):
            request.httpBody = data
        default: break
        }
        configure.logger.log(request: request)
        request.allHTTPHeaderFields = configure.headers
        request.httpMethod = endpoint.method.name
        
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = ["Content-Type": "application/json"]
        
        let session = URLSession(configuration: configuration)
        
        let (data, response) = try await session.data(for: request)
        guard let urlResponse = response as? HTTPURLResponse else {
            configure.logger.log(error: NetworkError.invalidaServerResponse)
            throw NetworkError.invalidaServerResponse
        }
        
        guard (200...300).contains(urlResponse.statusCode) else  {
            configure.logger.log(error: NetworkError.invalidaServerResponseStatusCode)
            throw NetworkError.invalidaServerResponseStatusCode
        }
        
        guard let result = try? JSONDecoder().decode(R.self, from: data) else {
            throw NetworkError.decodingError
        }
        
        configure.logger.log(responseData: data, response: response)
        return result
    }
}

// MARK: - Logger

public final class DefaultNetworkErrorLogger: NetworkErrorLogger {
    public init() { }

    public func log(request: URLRequest) {
        print("-------------")
        print("✅ request: \(String(describing: request.url))")
        print("✅ headers: \(String(describing: request.allHTTPHeaderFields))")
        print("✅ method: \(String(describing: request.httpMethod)) ")
        if let httpBody = request.httpBody, let result = ((try? JSONSerialization.jsonObject(with: httpBody, options: []) as? [String: AnyObject]) as [String: AnyObject]??) {
            debugPrint("✅ body: \(String(describing: result))")
        } else if let httpBody = request.httpBody, let resultString = String(data: httpBody, encoding: .utf8) {
            debugPrint("✅ body: \(String(describing: resultString))")
        }
    }

    public func log(responseData data: Data?, response: URLResponse?) {
        guard let data = data else { return }
        if let dataDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            debugPrint("✅ responseData: \(String(describing: dataDict))")
        }
    }

    public func log(error: Error) {
        debugPrint("🛑🛑🛑🛑🛑🛑\(error)")
    }
}

extension Data {
    var prettyPrintedJSONString: NSString? { /// NSString gives us a nice sanitized debugDescription
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }

        return prettyPrintedString
    }
}
