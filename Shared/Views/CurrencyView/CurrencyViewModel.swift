//
//  CurrencyViewModel.swift
//  Converter (iOS)
//
//  Created by Johann on 12/8/22.
//

import SwiftUI

final class CurrencyViewModel: ObservableObject {
    
    var isSelectedAmount: Bool
    var showAmount: Bool
    var currency: Currency
    @ObservedObject var amount: Amount
    @Published var isBold: Font.Weight
    @Published var fontSize: CGFloat
    
    init(isSelectedAmount: Bool, showAmount: Bool, currency: Currency, amount: Amount, isBold: Font.Weight, fontSize: CGFloat) {
        self.isSelectedAmount = isSelectedAmount
        self.showAmount = showAmount
        self.currency = currency
        self.amount = amount
        self.isBold = isBold
        self.fontSize = fontSize
    }
}
