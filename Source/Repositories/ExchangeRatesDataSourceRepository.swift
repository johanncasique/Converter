//
//  CurrenciesDataSourceRepository.swift
//  Converter (iOS)
//
//  Created by johann casique on 6/12/22.
//

import Foundation

protocol ExchangeRatesDataSourceProtocol {
    func fetchCurrencies() async throws -> ExchangeRatesDTO
}

class ExchangeRatesDataSourceRepository: ExchangeRatesDataSourceProtocol {
        
    func fetchCurrencies() async throws -> ExchangeRatesDTO {
        let exchanche: ExchangeRateDO = try await APIManager().request(APIEndpoint.getExchangeRate())
        print(exchanche)
        return exchanche.getDTO()
    }
}
