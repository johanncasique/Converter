//
//  CurrenciesDataSourceRepository.swift
//  Converter (iOS)
//
//  Created by johann casique on 6/12/22.
//

import Foundation

protocol CurrenciesDataSourceRepositoryProtocol {
    func fetchCurrencies() async throws -> [String: Currency]?
}

class CurrenciesDataSourceRepository: CurrenciesDataSourceRepositoryProtocol {
   
    func fetchCurrencies() async throws -> [String: Currency]? {
//        let urlString = "https://api.getgeoapi.com/v2/currency/historical/2022-05-23?api_key=\(AppConfig.APP_KEY)"
        let urlString = "https://localhost:3000/countries"
        
        guard let url = URL(string: urlString) else { return nil }
        
        let session = URLSession(configuration: .default)
        
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
