//
//  ExchangeRatesDBRepository.swift
//  Converter (iOS)
//
//  Created by johann casique on 9/12/22.
//

import Foundation
protocol ExchangeRatesDBRepositoryProtocol: UserDefaultStorable {
    func saveRates(from dto: ExchangeRatesDTO) throws
    func getRatesFromDB() throws -> ExchangeRatesDTO
}

class ExchangeRatesDBRepository: ExchangeRatesDBRepositoryProtocol {
    
    typealias DataType = Data
    var key: String = "exchangeRateDTO"
    
    enum ExchangeRatesDBError: Error {
        case failedToSave
        case failedToGetFromDB
    }

    func saveRates(from dto: ExchangeRatesDTO) throws {
        let data = try dto.encode()
        try save(dataValue: data)
    }
    
    func getRatesFromDB() throws -> ExchangeRatesDTO {
        guard let data = try load() else {
            throw ExchangeRatesDBError.failedToGetFromDB
        }
        return try ExchangeRatesDTO.decode(from: data)
    }
    
    func saveAmount(value: String) {
        UserDefaults.standard.amountValue = value
    }
    
    func getSavedAmount() -> String? {
        UserDefaults.standard.amountValue
    }
}

extension UserDefaults {
    
    var amountValue: String? {
        get {
            return string(forKey: "amountValue")
        }
        set {
            setValue(newValue, forKey: "amountValue")
        }
    }
    
    var exchangeDTO: Data? {
        get {
            return data(forKey: "exchangeRateDTO")
        }
        set {
            set(newValue, forKey: "exchangeRateDTO")
        }
    }
    
    var countries: Data? {
        get {
            return data(forKey: "countries")
        }
        set {
            set(newValue, forKey: "countries")
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


