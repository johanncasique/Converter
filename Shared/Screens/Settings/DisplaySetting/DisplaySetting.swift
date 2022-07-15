//
//  DisplaySetting.swift
//  Converter (iOS)
//
//  Created by johann casique on 14/7/22.
//

import SwiftUI

struct DisplaySetting: View {
    
    @State var viewModel = DisplaySettingViewModel.options
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel) { model in
                    Section {
                        ForEach(model.options) { model in
                            handleList(with: model)
                        }
                    }
                }
            }
            .navigationTitle("Display")
        }
    }
    
    func handleList(with model: DisplaySettingOption) -> some View {
        if let currency = model.currency {
            return AnyView(CurrencyModelView(currency: currency,
                                     showAmount: true,
                                     amount: "95"))
        } else {
            return AnyView(Text(model.option ?? ""))
        }
    }
}

struct DisplaySetting_Previews: PreviewProvider {
    static var previews: some View {
        DisplaySetting()
    }
}
