//
//  CountryModel.swift
//  Converter
//
//  Created by johann casique on 24/5/22.
//

import Foundation

class Countries: ObservableObject, Identifiable {
    
    @Published var list = [CountryModel]()
    @Published var listSorted = [(letter: Character("A"),
                                  countries: [CountryModel]())]
    @Published var selectedCountries = [CountryModel]()
    
    init() {
        fetch()
    }
    
    public func fetch() {
        
        if let jsonData = getLocalData(),
           let decodeData = try? JSONDecoder().decode([CountryModel].self,
                                                      from:  jsonData) {
            list = decodeData
            
            let sections = Dictionary(grouping: decodeData) { (country) -> Character in
                return country.name.first!
                }
                .map { (key: Character, value: [CountryModel]) -> (letter: Character, countries: [CountryModel]) in
                    (letter: key, countries: value)
                }
                .sorted { (left, right) -> Bool in
                    left.letter < right.letter
                }
                
            
            print(sections)
            listSorted = sections
            print("DecodeData \(decodeData)")
        }
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
    
    let name, dialCode, code: String
    let id = UUID()
    
    enum CodingKeys: String, CodingKey {
        case name
        case dialCode = "dial_code"
        case code
    }
    
    func encode() throws -> Data {
        let encoder = JSONEncoder()
        return try encoder.encode(self)
    }
    
    static func decode(from data: Data) throws -> CountryModel {
        let decoder = JSONDecoder()
        return try decoder.decode(CountryModel.self, from: data)
    }
}
