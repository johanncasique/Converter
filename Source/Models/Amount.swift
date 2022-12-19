//
//  Amount.swift
//  Converter (iOS)
//
//  Created by johann casique on 11/12/22.
//

import Foundation

class Amount: ObservableObject {
    
    enum Decimal: Int, Codable {
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


