//
//  Service.swift
//  Converter (iOS)
//
//  Created by johann casique on 27/9/21.
//

import Foundation

final class CurrencyService {
    func fetchCurrencies() async throws -> [String: Currency]? {
        let urlString = "https://api.getgeoapi.com/v2/currency/historical/2022-05-23?api_key=\(AppConfig.APP_KEY)"
        
        guard let url = URL(string: urlString) else { return nil }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        do {
            let model = try JSONDecoder().decode(CurrenciesModel.self, from: data)
            return model.rates
        } catch let error {
            print(error)
        }
        
        return [:]
    }
}
