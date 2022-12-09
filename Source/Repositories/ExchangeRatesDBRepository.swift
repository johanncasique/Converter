//
//  ExchangeRatesDBRepository.swift
//  Converter (iOS)
//
//  Created by johann casique on 9/12/22.
//

import Foundation
protocol ExchangeRatesDBRepositoryProtocol {
    func saveRates(from dto: ExchangeRateDTO) throws
    func getRatesFromDB() throws -> ExchangeRateDTO
}

class ExchangeRatesDBRepository: ExchangeRatesDBRepositoryProtocol {
    
    enum ExchangeRatesDBError: Error {
        case failedToSave
        case failedToGetFromDB
    }

    func saveRates(from dto: ExchangeRateDTO) throws {
        let data = try dto.encodeToData()
        try UserDefaults.standard.save(exchangeDTO: data)
    }
    
    func getRatesFromDB() throws -> ExchangeRateDTO {
        guard let data = UserDefaults.standard.getConversionRatesAndUpdateInformation() else {
            throw ExchangeRatesDBError.failedToGetFromDB
        }
        return try ExchangeRateDTO.decode(from: data)
    }
}

extension UserDefaults {
    
    var exchangeDTO: Data? {
        get {
            return data(forKey: "exchangeRateDTO")
        }
        set {
            set(newValue, forKey: "exchangeRateDTO")
        }
    }
    
    func save(exchangeDTO: Data?) throws {
        self.exchangeDTO = exchangeDTO
    }
    
    func getConversionRatesAndUpdateInformation() -> Data? {
        guard let exchangeDTO = exchangeDTO else { return nil }
        return exchangeDTO
    }
}


