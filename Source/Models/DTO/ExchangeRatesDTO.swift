//
//  ExchangeRatesDTO.swift
//  Converter (iOS)
//
//  Created by johann casique on 9/12/22.
//

import Foundation

// MARK: - CurrencyDTO
struct CurrencyDTO: Codable {
    let code: String
    let value: Double
}

// MARK: - ExchangeRatesDTO
struct ExchangeRatesDTO: Codable {
    let convertionRates: [CurrencyDTO]
    let updateInformation: UpdateInformation
    
    init(from exchangeRateDO: ExchangeRateDO) {
        self.convertionRates =  exchangeRateDO.conversionRates.map { CurrencyDTO(code: $0.key, value: $0.value) }
        self.updateInformation = UpdateInformation(from: exchangeRateDO)
    }
}

extension ExchangeRatesDTO {
    func encode() throws -> Data {
        let encoder = JSONEncoder()
        return try encoder.encode(self)
    }
    
    static func decode(from data: Data) throws -> ExchangeRatesDTO {
        let decoder = JSONDecoder()
        return try decoder.decode(ExchangeRatesDTO.self, from: data)
    }
}

// MARK: - UpdateInformation
struct UpdateInformation: Codable {
    var timeLastUpdate: Date
    var timeLastUpdateString: String
    var timeNextUpdate: Date
    var timeNextUpdateString: String
    
    init(from exchangeDO: ExchangeRateDO) {
        self.timeLastUpdate = Date(timeIntervalSince1970: TimeInterval(exchangeDO.timeLastUpdateUnix))
        self.timeLastUpdateString = exchangeDO.timeLastUpdateUTC
        self.timeNextUpdate = Date(timeIntervalSince1970: TimeInterval(exchangeDO.timeNextUpdateUnix))
        self.timeNextUpdateString = exchangeDO.timeNextUpdateUTC
    }
    
    func lastUpdate(with dateFormat: Date.DateFormat = .short) -> String {
        timeLastUpdate.dateToString(format: dateFormat)
    }
    
    func nextUpdate(withn dateFormat: Date.DateFormat = .short) -> String {
        timeNextUpdate.dateToString(format: dateFormat)
    }
}
