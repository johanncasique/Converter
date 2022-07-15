//
//  DisplaySettingViewModel.swift
//  Converter (iOS)
//
//  Created by johann casique on 14/7/22.
//

import Foundation

class DisplaySettingViewModel: ObservableObject {
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
                                        .init(option: "System", isSelected: true),
                                        .init(option: "Light", isSelected: false),
                                        .init(option: "Dark", isSelected: false)
                                      ]
                                     ),
                
                DisplaySettingOptions(title: "Text Size",
                                      options: [
                                        .init(option: "Use System Syze"),
                                        .init(option: "Bold Text")
                                      ]),
                
                DisplaySettingOptions(title: "Maximum Number of Decimal Digits",
                                      options: [
                                        .init(option:"No Digit Maximun"),
                                        .init(option: "2 Digits"),
                                        .init(option: "3 Digits"),
                                        .init(option: "4 Digits"),
                                        .init(option: "5 Digits")
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
    let option: String?
    let id = UUID()
    var isSelected: Bool
    
    init(currency: Currency? = nil, option: String? = nil, isSelected: Bool = false) {
        self.currency = currency
        self.option = option
        self.isSelected = isSelected
    }
}
