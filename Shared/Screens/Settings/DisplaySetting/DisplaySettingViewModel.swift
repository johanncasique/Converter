//
//  DisplaySettingViewModel.swift
//  Converter (iOS)
//
//  Created by johann casique on 14/7/22.
//

import Foundation
import SwiftUI

class DisplaySettingViewModel: ObservableObject {
    
    @Published var decimalSetting = Options.Decimal.two
    
    enum Options {
        
        enum Title: String {
            case preview = "Preview"
            case appearance = "Appearance"
        }
        
        enum Appeareance: String {
            case system = "System"
            case light = "Ligth"
            case dark = "Dark"
        }
        
        enum TexSize: String {
            case system = "Use System Syze"
            case bold = "Bold Text"
        }
        
        enum Decimal: String {
            case two = "2 Digits"
            case three = "3 Digits"
            case four = "4 Digits"
            case five = "5 Digits"
        }
    }
    
    @Published var options: [DisplaySettingOptions] = {
        return [DisplaySettingOptions(title: "Preview",
                                      options: [
                                        .init(currency: .init(currencyName: "CAD",
                                                              rate: "1",
                                                              rateForAmount: "1",
                                                              imageName: "CA",
                                                              countryCode: "CA"))
                                      ]),
                
                DisplaySettingOptions(title: "Appearance",
                                      options: [ .init(appearance: DisplaySettingAppeareance(name: "System", isSelected: true)),
                                                 .init(appearance: DisplaySettingAppeareance(name: "Ligth", isSelected: false)),
                                                 .init(appearance: DisplaySettingAppeareance(name: "Dark", isSelected: false))
                                               ]
                                     ),
                
                DisplaySettingOptions(title: "Text Size",
                                      options: [
                                        .init(text: DisplaySettingText(name: "Use System Syze", systemSizeToggle: true, boldTextToggle: false)),
                                        .init(text: DisplaySettingText(name: "Bold Text", systemSizeToggle: false, boldTextToggle: true))
                                      ]),
                
                
                DisplaySettingOptions(title: "Maximum Number of Decimal Digits",
                                      options: [
                                        .init(decimal: DisplaySettingDecimal(name: "No Digit Maximun", isSelected: true)),
                                        .init(decimal: DisplaySettingDecimal(name: Options.Decimal.two.rawValue, isSelected: false)),
                                        .init(decimal: DisplaySettingDecimal(name: Options.Decimal.three.rawValue, isSelected: false)),
                                        .init(decimal: DisplaySettingDecimal(name: Options.Decimal.four.rawValue, isSelected: false)),
                                        .init(decimal: DisplaySettingDecimal(name: Options.Decimal.five.rawValue, isSelected: false))
                                      ])
        ]
        
    }()
    
    
}

struct DisplaySettingOptions: Identifiable {
    
    let title: String
    var options: [DisplaySettingOption]
    let id = UUID()
}

struct DisplaySettingOption: Identifiable {
    
    var appearance: DisplaySettingAppeareance?
    let currency: Currency?
    var text: DisplaySettingText?
    let decimal: DisplaySettingDecimal?
    let id = UUID()
    
    init(appearance: DisplaySettingAppeareance? = nil, currency: Currency? = nil, decimal: DisplaySettingDecimal? = nil, text: DisplaySettingText? = nil) {
        self.appearance = appearance
        self.currency = currency
        self.decimal = decimal
        self.text = text
    }
}

class DisplaySettingAppeareance: ObservableObject, Identifiable {
    
    let name: String
    let id = UUID()
    @Published var isSelected: Bool
    
    init(name: String, isSelected: Bool) {
        self.name = name
        self.isSelected = isSelected
    }
}

class DisplaySettingDecimal: ObservableObject, Identifiable {
    
    
    let name: String
    let id = UUID()
    @Published var isSelected: Bool
    
    init(name: String, isSelected: Bool) {
        self.name = name
        self.isSelected = isSelected
    }
}

class DisplaySettingText: ObservableObject, Identifiable {
    
    let name: String
    let id = UUID()
    @Published var systemSizeToggle: Bool
    @Published var boldTextToggle: Bool
    
    init(name: String, systemSizeToggle: Bool, boldTextToggle: Bool) {
        self.name = name
        self.systemSizeToggle = systemSizeToggle
        self.boldTextToggle = boldTextToggle
    }
    
    
    
}
