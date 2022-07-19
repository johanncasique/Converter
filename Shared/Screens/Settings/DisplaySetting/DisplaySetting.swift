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
                                    
                                    changeThemeSystem(from: option)
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
                Text(model.name ?? "")
            )
        }
    }
    
    func selectedViewConfiguration(with model: DisplaySettingOption) -> some View {
        return HStack {
            Text(model.name ?? "")
            Spacer()
            Image(systemName: "checkmark")
                .foregroundColor(.green)
        }
    }
    
    func changeThemeSystem(from option: DisplaySettingOption) {
        
        switch DisplaySettingViewModel.Options.Appeareance(rawValue: option.name ?? "") {
        case .system:
            UIApplication.shared.keyWindow?.overrideUserInterfaceStyle = UITraitCollection().userInterfaceStyle
        case .dark:
            let keyWindow = UIApplication.shared.windows.first(where: \.isKeyWindow)
            keyWindow?.overrideUserInterfaceStyle = .dark
        case .light:
            UIApplication.shared.keyWindow?.overrideUserInterfaceStyle = .light
        default: break
        }
        print(UITraitCollection().userInterfaceStyle)
    }
    
    func changeSystemSize(from option: DisplaySettingOption) {
        switch DisplaySettingViewModel.Options.TexSize(rawValue: option.name ?? "") {
        case .system:
            if option.
        case .bold:
        default: break
        }
    }
}

struct DisplaySetting_Previews: PreviewProvider {
    static var previews: some View {
        DisplaySetting()
    }
}
