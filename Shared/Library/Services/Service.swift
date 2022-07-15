//
//  Service.swift
//  Converter (iOS)
//
//  Created by johann casique on 27/9/21.
//

import Foundation


final class CurrencyService: NSObject {
    func fetchCurrencies() async throws -> [String: Currency]? {
//        let urlString = "https://api.getgeoapi.com/v2/currency/historical/2022-05-23?api_key=\(AppConfig.APP_KEY)"
        let urlString = "https://localhost:3000/countries"
        
        guard let url = URL(string: urlString) else { return nil }
        
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        
        let (data, _) = try await session.data(from: url)
        
        print(data.prettyPrintedJSONString)
        
//        do {
//            let model = try JSONDecoder().decode(CurrenciesModel.self, from: data)
//            return model.rates
//        } catch let error {
//            print(error)
//        }
        
        return [:]
    }
}

extension CurrencyService: URLSessionDelegate {
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge) async -> (URLSession.AuthChallengeDisposition, URLCredential?) {
        
        let urlCredential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
        return (.useCredential, urlCredential)
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
