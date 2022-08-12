//
//  CurrencyView.swift
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

struct CurrencyView: View {
    
   @ObservedObject var viewModel: CurrencyViewModel
    
    init(with viewModel: CurrencyViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        HStack(alignment: .center) {
            Image(viewModel.currency.imageName ?? "")
                .resizable()
                .scaledToFill()
                .frame(width: 40, height: 40).clipped().cornerRadius(4)
                .padding(.leading, 0)
            VStack(alignment: .leading) {
                Text(viewModel.currency.countryCode)
                    .font(.system(size: viewModel.fontSize, weight: viewModel.isBold))
                    .foregroundColor(.secondary)
                Text(viewModel.currency.currencyName)
                    .font(.system(size: viewModel.fontSize, weight: viewModel.isBold))
                    .foregroundColor(.primary)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 8) {
                if viewModel.showAmount {
                    if viewModel.isSelectedAmount {
                        selectedAmount("\(viewModel.amount.description)", isBold: viewModel.isBold)
                    } else {
                        unSelectedAmountView("\(viewModel.amount.description)", isBold: viewModel.isBold)
                    }
                }
            }
        }
    }
    
    func unSelectedAmountView(_ amount: String, isBold: Font.Weight) -> some View {
        Text(amount)
            .font(.system(size: viewModel.fontSize, weight: isBold))
            .foregroundColor(.green)
            .padding(5)
            .background(Color.green.opacity(0.25))
            .cornerRadius(10)
        
    }
    
    func selectedAmount(_ amount: String, isBold: Font.Weight) -> some View {
        Text(amount)
            .font(.system(size: viewModel.fontSize, weight: isBold))
            .padding(5)
            .foregroundColor(.white)
            .background(Color(.systemGreen))
            .cornerRadius(10)
    }
    
}


struct CurrencyView_Previews: PreviewProvider {
    
    private static var viewModel: CurrencyViewModel = {
        return .init(isSelectedAmount: true,
                     showAmount: true,
                     currency: currencyData,
                     amount: amountData,
                     isBold: .bold,
                     fontSize: 14)
    }()
    
    private static var currencyData = {
        return Currency(currencyName: "EU",
                        rate: "1",
                        rateForAmount: "1",
                        imageName: "EU",
                        countryCode: "EU")
    }()
    
    private static var amountData = {
        return Amount(value: 12.45,
                      minimunDecimal: Amount.Decimal.two)
    }()
    
    static var previews: some View {
        Group {
            CurrencyView(with: viewModel)
            .previewLayout(.sizeThatFits)
            .padding()
            .previewDisplayName("Currency View Light Mode")
            
            
            CurrencyView(with: viewModel)
            .previewLayout(.sizeThatFits)
            .padding()
            .previewDisplayName("Currency View Dark Mode")
            .preferredColorScheme(.dark)
        }
    }
}
