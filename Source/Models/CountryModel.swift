//
//  CountryModel.swift
//  Converter
//
//  Created by johann casique on 24/5/22.
//

import Foundation
import SwiftUI

class Countries: ObservableObject, Identifiable {
    
    @Published var list = [CountryModel]()
    @Published var listSorted = [(letter: Character("A"),
                                  countries: [CountryModel]())]
    @Published var selectedCountries = [CountryModel]()
    
    public func fetch() throws -> [CountryModel] {
        
        guard let jsonData = getLocalData() else {
            fatalError()
        }
        let decodeData = try JSONDecoder().decode([CountryModel].self,
                                                  from: jsonData)
        list = decodeData
        return list
    }
    
    private func getLocalData() -> Data? {
        do {
            if let bundlePath = Bundle.main.path(forResource: "CountryData",
                                                 ofType: "json"),
               let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                return jsonData
            }
        } catch let error {
            print("Error getting data: \(error.localizedDescription)")
        }
        return nil
    }
}

struct CountryModel: Codable, Identifiable, Hashable {
    let countryCode, countryName, currencyCode, population, capital: String
    let continentName: ContinentName
    var rate: Double
    var id = UUID()
    
    enum CodingKeys: String, CodingKey {
        case countryCode, countryName, currencyCode, population, capital, rate
        case continentName
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        countryCode = try container.decode(String.self, forKey: .countryCode)
        countryName = try container.decode(String.self, forKey: .countryName)
        currencyCode = try container.decode(String.self, forKey: .currencyCode)
        population = try container.decode(String.self, forKey: .population)
        capital = try container.decode(String.self, forKey: .capital)
        continentName = try container.decode(ContinentName.self, forKey: .continentName)
        rate = try container.decodeIfPresent(Double.self, forKey: .rate) ?? 0
      }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(countryCode, forKey: .countryCode)
        try container.encode(countryName, forKey: .countryName)
        try container.encode(currencyCode, forKey: .currencyCode)
        try container.encode(population, forKey: .population)
        try container.encode(capital, forKey: .capital)
        try container.encode(continentName, forKey: .continentName)
        try container.encodeIfPresent(rate, forKey: .rate)
    }
    
    func encode() throws -> Data {
        let encoder = JSONEncoder()
        return try encoder.encode(self)
    }
    
    static func decode(from data: Data) throws -> CountryModel {
        let decoder = JSONDecoder()
        return try decoder.decode(CountryModel.self, from: data)
    }
    
    func getDTO() -> CountryModelDTO {
        return CountryModelDTO(from: self)
    }
}

enum ContinentName: String, Codable {
    case africa = "Africa"
    case antarctica = "Antarctica"
    case asia = "Asia"
    case europe = "Europe"
    case northAmerica = "North America"
    case oceania = "Oceania"
    case southAmerica = "South America"
}


struct CountryModelDTO: Identifiable {
    let countryCode, countryName, currencyCode, capital: String
    var rate: Double
    var id: UUID
    @State var isShowingCalculator: Bool = false
    
    init(from model: CountryModel) {
        self.countryName = model.countryName
        self.countryCode = model.countryCode
        self.currencyCode = model.currencyCode
        self.capital = model.capital
        self.rate = model.rate
        self.id = model.id
    }
}
