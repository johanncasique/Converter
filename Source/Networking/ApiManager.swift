//
//  Service.swift
//  Converter (iOS)
//
//  Created by johann casique on 27/9/21.
//

import Foundation

//protocol APIManagerProtocol {
//    func request<R: Codable>(_ endpoint: Endpoint<R>, configure: NetworkConfigurable) async throws -> R
//}

import Foundation

class APIManager {
    private let urlSession = URLSession(configuration: .default)
    private let networkErrorLogger: NetworkErrorLogger
    
    init(networkErrorLogger: NetworkErrorLogger = DefaultNetworkErrorLogger()) {
        self.networkErrorLogger = networkErrorLogger
    }

    func request<T: Codable>(_ endpoint: Endpoint) async throws -> T {
        var urlComponents = URLComponents(
            url: endpoint.baseURL.appendingPathComponent(endpoint.path),
            resolvingAgainstBaseURL: false
        )
        if let parameters = endpoint.parameters {
            urlComponents?.queryItems = parameters
        }
        guard let url = urlComponents?.url else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.headers
        
        networkErrorLogger.log(request: request)

        let (data, response) = try await urlSession.data(for: request)
        networkErrorLogger.log(responseData: data, response: response)

        guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
            throw APIError.serverError(statusCode: (response as? HTTPURLResponse)?.statusCode ?? -1)
        }

        do {
            let decoder = JSONDecoder()
            let responseObject = try decoder.decode(T.self, from: data)
            return responseObject
        } catch let error {
            networkErrorLogger.log(error: error)
            throw APIError.decodingError(error)
        }
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
