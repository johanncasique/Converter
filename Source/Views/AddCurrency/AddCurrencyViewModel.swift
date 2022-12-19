//
//  AddCurrencyViewModel.swift
//  Converter (iOS)
//
//  Created by johann casique on 10/12/22.
//

import Foundation
import SwiftUI

class AddCurrencyViewModel: ObservableObject {
    
    private var dbRepository: ExchangeRatesDBRepository
    @Published var multiSelection = Set<UUID>()
    @Published var editMode: EditMode = .active
    @Published var countriesSorted = [(letter: Character("A"),
                                 countries: [CountryModel]())]
    @Published var countries = Countries()
    var filterCountries = [CountryModel]()
    
    init(dbRepository: ExchangeRatesDBRepository) {
        self.dbRepository = dbRepository
        getCountriesSorted()
    }
    
    func getCountriesSorted() {
        
        do {
            let fecthCountries = try countries.fetch()
            let exchangeDB = try dbRepository.getRatesFromDB()
            
            filterCountries = fecthCountries.filter { country in
                exchangeDB.convertionRates.contains { rates in
                    // Check if the currency code in rates starts with the country code in country.
                    // If so, both codes are considered equal and the country is included in the resulting array.
                    rates.code.starts(with: country.currencyCode)
                }
            }
            
            filterCountries = filterCountries.map { country in
                var countryTemp = country
                let matchingRate = exchangeDB.convertionRates.filter { rates in
                        rates.code.starts(with: country.currencyCode)
                    }.first
                
                if let rateValue = matchingRate?.value {
                    countryTemp.rate = rateValue
                 }

                 return countryTemp
            }
            
            let sections = Dictionary(grouping: filterCountries) { (country) -> Character in
                return country.countryName.first!
                }
                .map { (key: Character, value: [CountryModel]) -> (letter: Character, countries: [CountryModel]) in
                    (letter: key, countries: value)
                }
                .sorted { (left, right) -> Bool in
                    left.letter < right.letter
                }
            countriesSorted = sections
            
        } catch {
            print(error)
        }
    }
}
