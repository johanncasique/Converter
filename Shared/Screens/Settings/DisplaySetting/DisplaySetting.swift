//
//  DisplaySetting.swift
//  Converter (iOS)
//
//  Created by johann casique on 14/7/22.
//

import SwiftUI

struct DisplaySetting: View {
    
    @ObservedObject var viewModel = DisplaySettingViewModel()
    
    var body: some View {
        NavigationView {
            List {
                ForEach($viewModel.options, id: \.id) { $model in
                    Section {
                        ForEach($model.options) { $option in
                            handleList(with: option)
                                .onTapGesture {
                                    for i in 0..<model.options.count {
                                        model.options[i].isSelected = false
                                    }
                                    option.isSelected.toggle()
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
            }
            .navigationTitle("Display")
        }
        .navigationViewStyle(.stack)
    }
    
    func handleList(with model: DisplaySettingOption) -> some View {
        if let currency = model.currency {
            return AnyView(CurrencyModelView(currency: currency,
                                             showAmount: true,
                                             amount: "95"))
        } else {
            if model.isSelected == true {
                return AnyView(selectedViewConfiguration(with: model))
            }
            return AnyView(
                Text(model.option ?? "")
            )
        }
    }
    
    func selectedViewConfiguration(with model: DisplaySettingOption) -> some View {
        return HStack {
            Text(model.option ?? "")
            Spacer()
            Image(systemName: "checkmark")
                .foregroundColor(.green)
        }
    }
}

struct DisplaySetting_Previews: PreviewProvider {
    static var previews: some View {
        DisplaySetting(themeSelection: .init())
    }
}
