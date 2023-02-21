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

class HomeViewModel: ObservableObject {
    
    @Published var viewState: ViewState = .loading
    @Published var isShowingCalculator = false
    @Published var amountSelected = ""
    @Published var countrySaved = CountryModelDTO()
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
        do {
            amountSelected = dbRepository.getSavedAmount() ?? ""
            if let countrySaved = try? dbRepository.getCountrySaved() {
                self.countrySaved = countrySaved
            }
        }
        
        
        guard let dto = try? dbRepository.getRatesFromDB() else {
            Task { await fetchCurrency() }
            return
        }
        
        if let country = try? CountryDBRepository().getCountriesFromDB() {
            print("COUNTRY SAVED \(country)")
            countrySelected = country
        }
        let currenTime = Date()
        if currenTime >= dto.updateInformation.timeNextUpdate {
            debugPrint("-------Fetch from service")
            Task { await fetchCurrency() }
        } else {
            debugPrint("-------Fetch from DB \(dto)")
            exchangeDTO = dto
            do {
                try dbRepository.saveRates(from: dto)
                viewState = .loaded
            } catch {
                print("ERROR currencies \(error)")
                viewState = .error(.currencyNotFound)
            }
            
        }
    }
    
    
    func fetchCurrency() async {
        Task {
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
        }
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
    
    func currencyViewModel(with model: CountryModelDTO) -> CurrencyViewModel {
        let currency = Currency(currencyName: model.currencyCode,
                                imageName: model.countryCode,
                                countryCode: model.countryCode)
        saveAmounSelected()
        try? dbRepository.saveCountry(from: countrySaved)
        
        let amount = Amount(value: Double(amountSelected) ?? 1)
        print("COUNTRY MODEL SHOWED ON HOMEVIEW \(model)")
        if countrySaved.rate != 0 {
            if countrySaved.countryCode != model.countryCode {
                amount.value = amount.value * (countrySaved.rate * model.rate)
            }
        }
        let viewModel = CurrencyViewModel(isSelectedAmount: countrySaved.countryCode == model.countryCode ? true : false,
                                          showAmount: true,
                                          currency: currency,
                                          amount: amount,
                                          isBold: toggleBoldTextIsOn == true ? .bold : .regular,
                                          fontSize: fontSize)
        
        return viewModel
    }
    
    func saveAmounSelected() {
        dbRepository.saveAmount(value: amountSelected)
    }
}
