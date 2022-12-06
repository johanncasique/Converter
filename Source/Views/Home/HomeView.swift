//
//  CurrencyView.swift
//  Shared
//
//  Created by johann casique on 26/9/21.
//

import SwiftUI

struct HomeView: View {
    
    @ObservedObject var viewModel: HomeViewModel
    @ObservedObject private var countries = Countries()
    
    @State private var isShowingAddCountry = false
    @State private var selectionCountry = [CountryModel]()
    @State private var isShowingCalculator = false
    @State private var customAmount = ""
    @AppStorage("fontSize") private var fontSize = 0.0
    @AppStorage("toggleBoldTextIsOn") var toggleBoldTextIsOn = false
    
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
        
        let amount = Amount(value: Double(customAmount) ?? 0)
        
        return CurrencyView(with: .init(isSelectedAmount: true,
                                        showAmount: true,
                                        currency: currency,
                                        amount: amount,
                                        isBold: toggleBoldTextIsOn == true ? .bold : .regular,
                                        fontSize: fontSize))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HomeView(viewModel: .init(router: .init(),
                                      repository: .init()))
            HomeView(viewModel: .init(router: .init(),
                                      repository: .init()))
                .preferredColorScheme(.dark)
        }
    }
} 
