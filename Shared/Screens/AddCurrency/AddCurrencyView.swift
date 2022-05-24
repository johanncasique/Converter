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
    @State private var selection = 0
    @ObservedObject private var countries = Countries()
    
    var body: some View {
        NavigationView {
            VStack {
                HStack() {
                    Picker("options", selection: $selection) {
                        Text("All").tag(0)
                        Text("Crypto").tag(0)
                        Text("Metal").tag(0)
                    }
                    .pickerStyle(.segmented)
                }
                Spacer()
                List($countries.listSorted, id: \.letter) { $country in
                        Section(header: Text(String(country.letter))) {
                            ForEach(country.countries) { country in
                                CurrencyModelView(currency: Currency(currencyName: country.name,
                                                                     rate: "0",
                                                                     rateForAmount: "0", imageName: country.code,
                                                                     countryCode: country.code),
                                                  showAmount: false)
                            }
                        }
                    }
                .listStyle(.grouped)
            }
            .navigationTitle("Add Currency")
            .navigationBarTitleDisplayMode(.inline)
        }
        .searchable(text: $queryString,
                    prompt: "Currency, Country, Regions or Code")
    }
}


struct AddCurrencyView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AddCurrencyView()
            AddCurrencyView()
                .preferredColorScheme(.dark)
        }
    }
}
