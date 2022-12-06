//
//  SettingsViewModel.swift
//  Converter (iOS)
//
//  Created by johann casique on 13/7/22.
//

import Foundation

struct SettingsViewModel {
    
    enum Name: String {
        case display = "Display"
        case appIcon = "App Icon"
        case updateRates = "Update Rates"
        case location = "Location-Based Suggestions"
        case keypadSound = "Keypad Sounds"
        case widget = "Widget"
        case appleWatch = "Apple Watch"
        case inverse = "Inverse Currency"
        case feedback = "Feedback & Support"
        case rate = "Rate in the App Store"
        case terms = "Terms of Service"
        case privacy = "Privacy Policy"
    }
    
    static let settings: [Setting] = {
        
        return [
            Setting(options: [SettingType(name: Name.display.rawValue),
                              SettingType(name: Name.appIcon.rawValue),
                              SettingType(name: Name.updateRates.rawValue,
                                          subtitle: "Delayed 1 Hour"),
                              SettingType(name: Name.location.rawValue, goToDetail: false),
                              SettingType(name: Name.keypadSound.rawValue, goToDetail: false)
                             ]),
            
            Setting(options: [SettingType(name: Name.widget.rawValue),
                              SettingType(name: Name.appleWatch.rawValue)]),
            
            Setting(footer: "Regular currency conversion converts an amount from a base currency into many other currencies.\n\nInverse currency conversion converts an amount from each currency into a base currency.",
                    options: [SettingType(name: Name.inverse.rawValue,
                                          goToDetail: false)]),
            
            Setting(options: [SettingType(name: Name.feedback.rawValue),
                              SettingType(name: Name.rate.rawValue)]),
            
            Setting(footer: "Neither Currencv nor Currencv App LLC is liable for any errors or delays in currency data, or for anv actions taken in reliance on such data.\n\n Copyright © 2008-2022 Currency App LLC.",
                    options: [SettingType(name: Name.terms.rawValue),
                              SettingType(name: Name.privacy.rawValue
                                         )]),
        ]
        
    }()
}

struct SettingType: Hashable, Identifiable {
    let name: String
    let subtitle: String?
    let goTodetail: Bool
    let id = UUID()
    
    init(name: String, subtitle: String? = nil, goToDetail: Bool = true) {
        self.name = name
        self.subtitle = subtitle
        self.goTodetail = goToDetail
    }
}

struct Setting: Identifiable {
    let footer: String?
    let options: [SettingType]
    let id = UUID()
    
    init(footer: String? = nil, options: [SettingType]) {
        self.footer = footer
        self.options = options
    }
}


