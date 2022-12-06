//
//  CurrencyModel.swift
//  Converter (iOS)
//
//  Created by johann casique on 27/9/21.
//

import Foundation

struct CurrenciesModel: Decodable {
    let baseCurrencyCode, baseCurrencyName, amount, updatedDate: String
    let rates: [String: Currency]
    let status: String
    
    enum CodingKeys: String, CodingKey {
        case baseCurrencyCode = "base_currency_code"
        case baseCurrencyName = "base_currency_name"
        case amount
        case updatedDate = "updated_date"
        case rates, status
    }
}

struct Currency: Codable, Hashable {
    let currencyName, rate, rateForAmount: String
    var imageName: String?
    var countryCode: String
    
    enum CodingKeys: String, CodingKey {
        case currencyName = "currency_name"
        case rate
        case rateForAmount = "rate_for_amount"
        case imageName
        case countryCode
    }
}

class Amount: ObservableObject {
    
    enum Decimal: Int {
        case zero = 0
        case two = 2
        case three = 3
        case four = 4
        case five = 5
    }
    
    var value: Double
    @Published var minimunDecimal: Decimal
    
    init(value: Double, minimunDecimal: Decimal = .two) {
        self.value = value
        self.minimunDecimal = minimunDecimal
    }
}

extension Amount: CustomStringConvertible {
    
    private var valueFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = minimunDecimal.rawValue
        formatter.maximumIntegerDigits = 13
        return formatter
    }
    
    var description: String {
        return "\(valueFormatter.string(from: NSNumber(value: value)) ?? "")"
    }
}
