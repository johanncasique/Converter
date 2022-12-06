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
    
    @Published private(set) var currencys = [Currency]()
    let service = CurrencyService()
    private let router: HomeRouter
    private let repository: CurrenciesDataSourceRepository
    
    
    init(router: HomeRouter, repository: CurrenciesDataSourceRepository) {
        self.router = router
        self.repository = repository
        //Task { try? await service.fetchCurrencies() }
    }
    
    
    
    
    
    private func fetchCurrency() async {
        if var currencies = try? await
            repository.fetchCurrencies() {
            withAnimation {
                let currencyKeys = currencies.keys
                var currencyArray = [Currency]()
                for (key, _) in currencies {
                    currencies[key]?.countryCode = key
                    if let currency = currencies[key] {
                        currencyArray.append(currency)
                    }
                }
                
//                currencyKeys.forEach {
//                    if var currency = currencies[$0] {
//                        currencyArray.append(currency)
//                    }
//                }
                self.currencys = currencyArray
            }
        }
    }
}
