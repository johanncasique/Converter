//
//  CurrencyView.swift
//  Converter (iOS)
//
//  Created by Johann on 12/8/22.
//

import SwiftUI

struct CurrencyView: View {
    
    @ObservedObject var viewModel: CurrencyViewModel
    
    init(with viewModel: CurrencyViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        HStack(alignment: .center) {
            flagIcon
            VStack(alignment: .leading) {
                countryCodeLabel
                currencyNameLabel
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 8) {
                if viewModel.showAmount {
                    amountView(with: viewModel.amount, isBold: viewModel.isBold)
                }
            }
        }
    }
    
    var flagIcon: some View {
        Image(viewModel.currency.imageName ?? "")
            .resizable()
            .scaledToFill()
            .frame(width: 40, height: 40).clipped().cornerRadius(4)
            .padding(.leading, 0)
    }
    
    var countryCodeLabel: some View {
        Text(viewModel.currency.countryCode)
            .font(.system(size: viewModel.fontSize, weight: viewModel.isBold))
            .foregroundColor(.secondary)
    }
    
    var currencyNameLabel: some View {
        Text(viewModel.currency.currencyName)
            .font(.system(size: viewModel.fontSize, weight: viewModel.isBold))
            .foregroundColor(.primary)
    }
    
    func amountView(with data: Amount, isBold: Font.Weight) -> some View {
        let label = Text(data.description)
            .font(.system(size: viewModel.fontSize, weight: isBold))
            .padding(5)
        if viewModel.isSelectedAmount {
            return label
                .foregroundColor(.white)
                .background(Color(.systemGreen))
                .cornerRadius(10)
            
        } else {
            return label
                .foregroundColor(.green)
                .background(Color.green.opacity(0.25))
                .cornerRadius(10)
        }
    }
}


struct CurrencyView_Previews: PreviewProvider {
    
    private static var viewModel: CurrencyViewModel = {
        return .init(isSelectedAmount: false,
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
