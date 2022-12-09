//
//  CurrenciesDataSourceRepository.swift
//  Converter (iOS)
//
//  Created by johann casique on 6/12/22.
//

import Foundation

protocol ExchangeRatesDataSourceProtocol {
    func fetchCurrencies() async throws -> ExchangeRateDTO
    var configure: NetworkConfigurable { get }
}

class ExchangeRatesDataSourceRepository: ExchangeRatesDataSourceProtocol {
        
    var configure: NetworkConfigurable
    
    init(configure: NetworkConfigurable) {
        self.configure = configure
    }
    
    func fetchCurrencies() async throws -> ExchangeRateDTO {
        
        let exchanche = try await HTTPClient().request(APIEndpoint.getExchangeRate(),
                                                       configure: configure)
        print(exchanche)
        return exchanche.getDTO()
    }
}
