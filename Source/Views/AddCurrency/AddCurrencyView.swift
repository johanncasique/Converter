//
//  AddCurrencyView.swift
//  Converter
//
//  Created by johann casique on 23/5/22.
//

import Foundation
import SwiftUI

struct AddCurrencyView: View {
    
    @State private var queryString = ""
    @State private var typeOfCurrency: CurrencyOptions = .All
    @StateObject private var countries = Countries()
    @State private var editMode: EditMode = .active
    @State private var multiSelection = Set<UUID>()
    
    @Binding var isPresented: Bool
    @Binding var countrySelection: [CountryModel]
    
    
    enum CurrencyOptions: String, CaseIterable, Identifiable {
        case All, Crypto, Metal
        var id: Self { self }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                List($countries.listSorted, id: \.letter, selection: $multiSelection) { $country in
                    
                    Section(header: Text(String(country.letter))) {
                        ForEach(country.countries) { countryData in
                            showCountry(with: countryData)
                        }
                    }
                }
                .submitLabel(.done)
                .listStyle(.insetGrouped)
                .environment(\.editMode, $editMode)
                .toolbar {
                    AnyView(Button(action: onAdd) { Text("Done")})
                }
                .searchable(text: $queryString,
                            prompt: "Currency, Country, Regions or Code")
                .onSubmit(of: .search) {
                    print(queryString)
                }
            }
            .navigationTitle("Add Currency")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    func onAdd() {
        print("Close view with selection \(multiSelection.count)")
        print("Close view with selection \(multiSelection.debugDescription)")
        
        let filterCountries = countries.list.filter { multiSelection.contains($0.id) }
        
        print(filterCountries)
        isPresented.toggle()
        countries.selectedCountries.append(contentsOf: filterCountries)
        countrySelection.append(contentsOf: filterCountries)
    }
    
    func showCountry(with model: CountryModel) -> some View {
        
        let currency = Currency(currencyName: model.name,
                                rate: "0",
                                rateForAmount: "0", imageName: model.code,
                                countryCode: model.code)
        
        let viewModel = CurrencyViewModel(isSelectedAmount: false,
                                          showAmount: false,
                                          currency: currency,
                                          amount: .init(value: 7987),
                                          isBold: .bold,
                                          fontSize: 14)
        
        return CurrencyView(with: viewModel)
            .padding(5)
    }
}


struct AddCurrencyView_Previews: PreviewProvider {
    
    static var previews: some View {
        Group {
            AddCurrencyView(isPresented: .constant(false), countrySelection: .constant([]))
            AddCurrencyView(isPresented: .constant(false), countrySelection: .constant([]))
                .preferredColorScheme(.dark)
        }
    }
}
