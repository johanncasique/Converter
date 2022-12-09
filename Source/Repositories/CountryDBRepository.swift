//
//  CountryDBRepository.swift
//  Converter (iOS)
//
//  Created by johann casique on 9/12/22.
//

import Foundation

protocol CountryDBRepositoryProtocol: UserDefaultStorable {
    func saveCountries(from selection: [CountryModel]) throws
    func getCountriesFromDB() throws -> [CountryModel]
}

class CountryDBRepository: CountryDBRepositoryProtocol {
    
    enum CountryDBError: Error {
        case failedToSave
        case failedToGetFromDB
    }
    
    typealias DataType = Data
    var key: String = "countries"
    
    func saveCountries(from selection: [CountryModel]) throws {
        let data = try JSONEncoder().encode(selection)
        try save(value: data)
    }
    
    func getCountriesFromDB() throws -> [CountryModel] {
        guard let data = try load() else {
            throw CountryDBError.failedToGetFromDB
        }
        let model = try JSONDecoder().decode([CountryModel].self, from: data)
        return model
    }
}

protocol UserDefaultStorable {
    associatedtype DataType

    var key: String { get }

    func save(value: DataType) throws
    func load() throws -> DataType?
}

extension UserDefaultStorable where DataType: Codable {
    func save(value: DataType) throws {
        let encoder = JSONEncoder()
        let encoded = try encoder.encode(value)
        UserDefaults.standard.set(encoded, forKey: key)
    }

    func load() throws -> DataType? {
        if let data = UserDefaults.standard.data(forKey: key) {
            let value = try JSONDecoder().decode(DataType.self, from: data)
            return value
        }
        return nil
    }
}

