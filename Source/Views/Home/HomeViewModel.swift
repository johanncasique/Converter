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
    
    @Published var viewState: ViewState = .loading
    @Published var isShowingCalculator = false
    @Published var amountSelected = ""
    @Published var isShowingAddCountry = false
    @Published var countrySelected = [CountryModel]()
    private let repository: ExchangeRatesDataSourceRepository
    private let dbRepository: ExchangeRatesDBRepository
    private var exchangeDTO: ExchangeRatesDTO? = nil
    
    @AppStorage("fontSize") private var fontSize = 0.0
    @AppStorage("toggleBoldTextIsOn") var toggleBoldTextIsOn = false
    
    
    init(repository: ExchangeRatesDataSourceRepository, dbRepository: ExchangeRatesDBRepository) {
        self.repository = repository
        self.dbRepository = dbRepository
        checkDBRepositoryAndFetchCurrency()
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
    
    private func checkDBRepositoryAndFetchCurrency() {
        guard let dto = try? dbRepository.getRatesFromDB() else {
            Task { await fetchCurrency() }
            return
        }
        
        if let country = try? CountryDBRepository().getCountriesFromDB() {
            print("COUNTRY SAVED \(country)")
        }
        let currenTime = Date()
        if currenTime >= dto.updateInformation.timeNextUpdate {
            debugPrint("-------Fetch from service")
            Task { await fetchCurrency() }
        } else {
            debugPrint("-------Fetch from DB \(dto)")
            exchangeDTO = dto
            viewState = .loaded
        }
    }
    
    
    func fetchCurrency() async {
        do {
            exchangeDTO = try await repository.fetchCurrencies()
            guard let dto = exchangeDTO else {
                viewState = .error(.currencyNotFound)
                return
            }
            try dbRepository.saveRates(from: dto)
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
