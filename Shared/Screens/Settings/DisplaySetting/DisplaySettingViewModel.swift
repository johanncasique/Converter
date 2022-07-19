//
//  DisplaySettingViewModel.swift
//  Converter (iOS)
//
//  Created by johann casique on 14/7/22.
//

import Foundation

class DisplaySettingViewModel: ObservableObject {
    
    enum Options {
        
        enum Title: String {
            case preview = "Preview"
            case appearance = "Appearance"
        }
        
        enum Appeareance: String {
            case system = "System"
            case light = "Light"
            case dark = "Dark"
        }
        
        enum TexSize: String {
            case system = "Use System Syze"
            case bold = "Bold Text"
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
                                      options: [
                                        .init(name: "System", isSelected: true),
                                        .init(name: "Light", isSelected: false),
                                        .init(name: "Dark", isSelected: false)
                                      ]
                                     ),
                
                DisplaySettingOptions(title: "Text Size",
                                      options: [
                                        .init(name: "Use System Syze"),
                                        .init(name: "Bold Text")
                                      ]),
                
                DisplaySettingOptions(title: "Maximum Number of Decimal Digits",
                                      options: [
                                        .init(name:"No Digit Maximun"),
                                        .init(name: "2 Digits"),
                                        .init(name: "3 Digits"),
                                        .init(name: "4 Digits"),
                                        .init(name: "5 Digits")
                                      ])
        ]
        
    }()
}

struct DisplaySettingOptions: Identifiable {
    let title: String
    var options: [DisplaySettingOption]
    let id = UUID()
}

struct DisplaySettingOption: Hashable, Identifiable {
    
    let currency: Currency?
    let name: String?
    let id = UUID()
    var isSelected: Bool
    
    init(currency: Currency? = nil, name: String? = nil, isSelected: Bool = false) {
        self.currency = currency
        self.name = name
        self.isSelected = isSelected
    }
}
