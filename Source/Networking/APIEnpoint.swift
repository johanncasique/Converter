//
//  APIEnpoint.swift
//  Converter (iOS)
//
//  Created by johann casique on 8/12/22.
//

import Foundation

struct APIEndpoint {
    static func getExchangeRate() -> ExchangeRateEndpoint{
        return ExchangeRateEndpoint(currency: "PEN")
    }
}
