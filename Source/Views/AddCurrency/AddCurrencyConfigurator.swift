//
//  AddCurrencyConfigurator.swift
//  Converter (iOS)
//
//  Created by johann casique on 10/12/22.
//

import Foundation
import SwiftUI

struct AddCurrencyConfigurator {
    func setup(
        isPresented: Binding<Bool>,
        countrySelection: Binding<[CountryModel]>
    ) -> some View {
        let exchangeDbRespository = ExchangeRatesDBRepository()
        let viewModel = AddCurrencyViewModel(dbRepository: exchangeDbRespository)
        return AddCurrencyView(
            viewModel: viewModel,
            isPresented: isPresented,
            countrySelection: countrySelection
        )
    }
    
    static func preview() -> some View {
        let exchangeDbRespository = ExchangeRatesDBRepository()
        let viewModel = AddCurrencyViewModel(
            dbRepository: exchangeDbRespository
        )
        return AddCurrencyView(
            viewModel: viewModel,
            isPresented: .constant(false),
            countrySelection: .constant([])
        )
    }
}
