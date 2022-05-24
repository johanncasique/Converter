//
//  CurrencyView.swift
//  Shared
//
//  Created by johann casique on 26/9/21.
//

import SwiftUI

struct CurrencyView: View {
    
    @StateObject private var viewModel = CurrencyViewModel()
    @State private var isShowingAddCountry = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(0..<1, id: \.self) { i in
                    CurrencyModelView(currency:
                        Currency(currencyName: "Euro",
                                 rate: "1", rateForAmount: "1", imageName: "EU",
                                 countryCode: ""),
                        showAmount: true)
                        .padding(4)
                        .listRowSeparator(.hidden)
                    
                }
            }
            .navigationTitle(Text("Currency"))
            .toolbar {
                ToolbarItem(placement: .principal) {
                    toolBarItemView
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private var headerView: some View {
        HStack(alignment: .top) {
            Text("Currency")
                .foregroundColor(.primary)
                .font(Font.system(.largeTitle).bold())
            Spacer()
        }
        .padding(.horizontal, 16)
    }
    
    private var toolBarItemView: some View {
        HStack {
            Button(action: {
                isShowingAddCountry = true
                print("Plus Button clicked") }) {
                Image(systemName: "plus")
            }
                .sheet(isPresented: $isShowingAddCountry) {
                    AddCurrencyView()
                }
            Spacer()
            Button("Edit") {
                print("Click button")
            }
        }.padding(.horizontal, -5)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CurrencyView()
            CurrencyView()
                .preferredColorScheme(.dark)
        }
    }
}


struct CurrencyModelView: View {
    private var isSelectedAmount = true
    var showAmount = true
    var currency: Currency

    init(currency: Currency, showAmount: Bool) {
        self.currency = currency
        self.showAmount = showAmount
    }
    
    var body: some View {
        HStack(alignment: .center) {
            Image(currency.imageName ?? "")
                .resizable()
                .scaledToFill()
                .frame(width: 40, height: 40).clipped().cornerRadius(4)
                .padding(.leading, 0)
            VStack(alignment: .leading) {
                Text(currency.countryCode)
                    .font(Font.caption2)
                    .foregroundColor(.secondary)
                Text(currency.currencyName)
                    .font(.body)
                    .foregroundColor(.primary)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 8) {
                if showAmount {
                    if isSelectedAmount {
                        selectedAmount("3.000,00 €")
                    } else {
                        unSelectedAmountView("3.000,00 €")
                    }
                }
            }
        }
    }
    
    func unSelectedAmountView(_ amount: String) -> some View {
        Text(amount)
            .foregroundColor(.green)
            .font(.body)
            .padding(5)
            .background(Color.green.opacity(0.25))
            .cornerRadius(10)
            
    }
    
    func selectedAmount(_ amount: String) -> some View {
        Text(amount)
            .padding(5)
            .foregroundColor(.white)
            .background(Color(.systemGreen))
            .cornerRadius(10)
    }
}
