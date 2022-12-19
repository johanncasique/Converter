//
//  AddCurrencyView.swift
//  Converter
//
//  Created by johann casique on 23/5/22.
//

import Foundation
import SwiftUI

struct AddCurrencyView: View {
    
    @ObservedObject var viewModel: AddCurrencyViewModel
    
    @State private var queryString = ""
    @State private var typeOfCurrency: CurrencyOptions = .All
    
    @Binding var isPresented: Bool
    @Binding var countrySelection: [CountryModel]
    
    
    enum CurrencyOptions: String, CaseIterable, Identifiable {
        case All, Crypto, Metal
        var id: Self { self }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                List($viewModel.countriesSorted, id: \.letter, selection: $viewModel.multiSelection) { $country in
                    
                    Section(header: Text(String(country.letter))) {
                        ForEach(country.countries) { countryData in
                            showCountry(with: countryData)
                        }
                    }
                }
                .submitLabel(.done)
                .listStyle(.insetGrouped)
                .environment(\.editMode, $viewModel.editMode)
                .toolbar {
                    Button(action: onAdd) { Text("Done")}
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
        print("Close view with selection \(viewModel.multiSelection.count)")
        print("Close view with selection\(viewModel.multiSelection.debugDescription)")
        
        let filterCountries = viewModel.filterCountries.filter { viewModel.multiSelection.contains($0.id) }
        
        print(filterCountries)
        viewModel.countries.selectedCountries.append(contentsOf: filterCountries)
        countrySelection.append(contentsOf: filterCountries)
        do {
            try CountryDBRepository().saveCountries(from: countrySelection)
        } catch {
            fatalError()
        }
        isPresented.toggle()
    }
    
    func showCountry(with model: CountryModel) -> some View {
        
        let currency = Currency(currencyName: model.currencyCode,
                                imageName: model.countryCode,
                                countryCode: model.countryCode)
        
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
            AddCurrencyConfigurator.preview()
            AddCurrencyConfigurator.preview()
                .preferredColorScheme(.dark)
        }
    }
}
