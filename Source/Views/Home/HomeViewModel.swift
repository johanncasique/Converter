//
//  CurrencyViewModel.swift
//  Converter (iOS)
//
//  Created by johann casique on 28/9/21.
//

import SwiftUI
import Swift
import CoreData
import UIKit

@MainActor
class HomeViewModel: ObservableObject {
    
    //@Published private(set) var currencys = [Currency]()
    @Published var viewState: ViewState = .none
    @Published var isShowingCalculator = false
    @Published var amountSelected = ""
    @Published var isShowingAddCountry = false
    @Published var selectionCountry = [CountryModel]()
    let service = CurrencyService()
    private let router: HomeRouter
    private let repository: CurrenciesDataSourceRepository
    
    @AppStorage("fontSize") private var fontSize = 0.0
    @AppStorage("toggleBoldTextIsOn") var toggleBoldTextIsOn = false
    
    
    init(router: HomeRouter, repository: CurrenciesDataSourceRepository) {
        self.router = router
        self.repository = repository
        //Task { try? await service.fetchCurrencies() }
    }
    
    enum ViewState {
        case none
        case loading
        case loaded
        case error(HomeViewModelError)
    }
    
    enum HomeViewModelError: Error {
        case currencyNotFound
    }
    
    
    private func fetchCurrency() async {
        if var currencies = try? await repository.fetchCurrencies() {
            withAnimation {
                var currencyArray = [Currency]()
                for (key, _) in currencies {
                    currencies[key]?.countryCode = key
                    if let currency = currencies[key] {
                        currencyArray.append(currency)
                    }
                }
                //self.currencys = currencyArray
                print("CURRENCY ARRAY \(currencyArray)")
                viewState = .loaded
            }
        } else {
            viewState = .error(.currencyNotFound)
        }
    }
    
    func currencyViewModel(with model: CountryModel) -> CurrencyViewModel {
        let currency = Currency(currencyName: model.name,
                                rate: "1",
                                rateForAmount: "1",
                                imageName: model.code,
                                countryCode: model.code)
        
        let amount = Amount(value: Double(amountSelected) ?? 0)
        
        let viewModel = CurrencyViewModel(isSelectedAmount: true,
                                          showAmount: true,
                                          currency: currency,
                                          amount: amount,
                                          isBold: toggleBoldTextIsOn == true ? .bold : .regular,
                                          fontSize: fontSize)
        
        return viewModel
    }
}
