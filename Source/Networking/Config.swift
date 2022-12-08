//
//  Config.swift
//  Converter (iOS)
//
//  Created by johann casique on 27/9/21.
//

import Foundation

struct AppConfig {

    static let APP_KEY = "7772184500b3f1260d96c3c5"
    
    static func apiConfig() -> NetworkConfigurable {
        let baseURL = URL(string: "https://v6.exchangerate-api.com/v6/\(APP_KEY)")
        return ApiDataNetworkConfig(baseURL: baseURL!)
    }
    
//    lazy var apiConfiguration: ApiDataNetworkConfig = {
//        let baseURL = URL(string: "https://v6.exchangerate-api.com/v6/\(APP_KEY)")
//        return ApiDataNetworkConfig(baseURL: baseURL!)
//    }()
    
}
