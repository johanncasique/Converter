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
    @Published var viewState: ViewState = .loading
    @Published var isShowingCalculator = false
    @Published var amountSelected = ""
    @Published var isShowingAddCountry = false
    @Published var selectionCountry = [CountryModel]()
    private let repository: CurrenciesDataSourceRepository
    private var exchangeDTO: ExchangeRateDTO? = nil
    
    @AppStorage("fontSize") private var fontSize = 0.0
    @AppStorage("toggleBoldTextIsOn") var toggleBoldTextIsOn = false
    
    
    init(repository: CurrenciesDataSourceRepository) {
        self.repository = repository
        Task { await fetchCurrency() }
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
    
    
    func fetchCurrency() async {
        do {
            exchangeDTO = try await repository.fetchCurrencies()
            print("CURRENCY ARRAY \(exchangeDTO)")
            fireNextFetch()
            viewState = .loaded
        } catch {
            print("ERROR currencies \(error)")
            viewState = .error(.currencyNotFound)
        }
//        if var currencies = try? await repository.fetchCurrencies() {
//            
//                var currencyArray = [Currency]()
////                for (key, _) in currencies {
////                    currencies[key]?.countryCode = key
////                    if let currency = currencies[key] {
////                        currencyArray.append(currency)
////                    }
////                }
//                //self.currencys = currencyArray
//                
//            
//        } else {
//            viewState = .error(.currencyNotFound)
//        }
    }
    
    private func fireNextFetch() {
        guard let exchangeDTO = self.exchangeDTO else {
            fatalError()
        }
        let timeInterval = exchangeDTO.updateInformation.timeNextUpdate.timeIntervalSinceNow
        Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false) { _ in
            Task { await self.fetchCurrency() }
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
