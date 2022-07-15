//
//  CurrencyView.swift
//  Shared
//
//  Created by johann casique on 26/9/21.
//

import SwiftUI

struct CurrencyView: View {
    
    @StateObject private var viewModel = CurrencyViewModel()
    @ObservedObject private var countries = Countries()
    
    @State private var isShowingAddCountry = false
    @State private var selectionCountry = [CountryModel]()
    @State private var isShowingCalculator = false
    @State private var customAmount = ""
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(selectionCountry, id: \.self) { i in
                        
                        Button {
                            isShowingCalculator.toggle()
                        } label: {
                            viewModel(with: i)
                            .padding(4)
                            .listRowSeparator(.hidden)
                        }
                        .sheet(isPresented: $isShowingCalculator) {
                            CalculatorView(isPresented: $isShowingCalculator,
                                           customAmount: $customAmount)
                        }
                    }
                }
                .navigationTitle(Text("Currency"))
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        toolBarItemView
                    }
                }
            }
        }
        .navigationViewStyle(.stack)
        .toolbar {
            AnyView(Image(systemName: "minus.slash.plus"))
        }
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
                isShowingAddCountry = true }) {
                Image(systemName: "plus")
            }
                .sheet(isPresented: $isShowingAddCountry) {
                    AddCurrencyView(isPresented: $isShowingAddCountry, countrySelection: $selectionCountry)
                }
            Spacer()
            Button("Edit") {
                print("Click button")
            }
        }.padding(.horizontal, -5)
    }
    
    func selectedCountriesData() -> String {
        return "\(selectionCountry.count)"
    }
    
    func viewModel(with model: CountryModel) -> some View {
        
        let currency = Currency(currencyName: model.name,
                                rate: "1",
                                rateForAmount: "1",
                                imageName: model.code,
                                countryCode: model.code)
        
        return CurrencyModelView(currency: currency, showAmount: true,
                                 amount: customAmount)
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
    var amount: String

    init(currency: Currency, showAmount: Bool, amount: String) {
        self.currency = currency
        self.showAmount = showAmount
        self.amount = amount
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
                        selectedAmount("\(amount) €")
                    } else {
                        unSelectedAmountView("\(amount) €")
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
