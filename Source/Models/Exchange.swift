//
//  Exchange.swift
//  Converter (iOS)
//
//  Created by johann casique on 8/12/22.
//

import Foundation

// MARK: - ExchangeRate
struct ExchangeRateDTO: Codable {
    let convertionRates: [String: Double]
    let updateInformation: UpdateInformation
    
    init(exchangeRateDO: ExchangeRateDO) {
        self.convertionRates = exchangeRateDO.conversionRates
        self.updateInformation = UpdateInformation(from: exchangeRateDO)
    }
    
    func encodeToData() throws -> Data {
        do {
            let encoder = JSONEncoder()
            return try encoder.encode(self)
        } catch {
            throw error
        }
    }
    
    static func decode(from data: Data) throws -> ExchangeRateDTO {
        let decoder = JSONDecoder()
        return try decoder.decode(ExchangeRateDTO.self, from: data)
    }
}



struct ExchangeRateDO: Codable {
    let result: String
    let documentation, termsOfUse: String
    let timeLastUpdateUnix: Int
    let timeLastUpdateUTC: String
    let timeNextUpdateUnix: Int
    let timeNextUpdateUTC, baseCode: String
    let conversionRates: [String: Double]

    enum CodingKeys: String, CodingKey {
        case result, documentation
        case termsOfUse = "terms_of_use"
        case timeLastUpdateUnix = "time_last_update_unix"
        case timeLastUpdateUTC = "time_last_update_utc"
        case timeNextUpdateUnix = "time_next_update_unix"
        case timeNextUpdateUTC = "time_next_update_utc"
        case baseCode = "base_code"
        case conversionRates = "conversion_rates"
    }
    
    func getDTO() -> ExchangeRateDTO {
        return ExchangeRateDTO(exchangeRateDO: self)
    }
}

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
