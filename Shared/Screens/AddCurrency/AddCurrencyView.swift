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
    @StateObject private var currencyViewModel = CurrencyViewModel()
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
                HStack() {
                    Picker("options", selection: $typeOfCurrency) {
                        Text("All").tag(CurrencyOptions.All)
                        Text("Crypto").tag(CurrencyOptions.Crypto)
                        Text("Metal").tag(CurrencyOptions.Metal)
                    }
                    .pickerStyle(.segmented)
                    .padding()
                }
                Spacer()
                List($countries.listSorted, id: \.letter, selection: $multiSelection) { $country in
                    
                    Section(header: Text(String(country.letter))) {
                        ForEach(country.countries) { country in
                            CurrencyModelView(currency: Currency(currencyName: country.name,
                                                                 rate: "0",
                                                                 rateForAmount: "0", imageName: country.code,
                                                                 countryCode: country.code),
                                              showAmount: false,
                                              amount: .init(value: 9675),
                                              isBold: .bold, fontSize: 14)
                            .padding(5)
                        }
                    }
                }
                .submitLabel(.done)
                .listStyle(.insetGrouped)
                .environment(\.editMode, $editMode)
                .toolbar {
                    AnyView(Button(action: onAdd) { Text("Done")})
                }
            }
            .navigationTitle("Add Currency")
            .navigationBarTitleDisplayMode(.inline)
        }
        .searchable(text: $queryString,
                    prompt: "Currency, Country, Regions or Code")
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
