//
//  DisplaySetting.swift
//  Converter (iOS)
//
//  Created by johann casique on 14/7/22.
//

import SwiftUI

struct DisplaySetting: View {
    
    @ObservedObject var viewModel = DisplaySettingViewModel()
    @State private var systemCheck = ""
    @State private var showDetail = false
    @AppStorage("Theme") var selectedTheme = ""
    @AppStorage("DecimalConfiguration") var decimalConfigurationSaved = DisplaySettingViewModel.Options.Decimal.two.rawValue
    
    var body: some View {
        NavigationView {
            List {
                ForEach($viewModel.options, id: \.id) { $model in
                    Section {
                        ForEach($model.options) { $option in
                            handleList(with: option)
                                .onTapGesture {
                                    
                                    for i in 0..<model.options.count {
                                        if let appearances = model.options[i].appearance {
                                            appearances.isSelected = false
                                            systemCheck = ""
                                        }

                                        if let decimal = model.options[i].decimal {
                                            decimal.isSelected = false
                                            systemCheck = ""
                                        }
                                    }
                                    
                                    if let appearance = option.appearance {
                                        systemCheck = ""
                                        appearance.isSelected = true
                                        selectedTheme = appearance.name
                                    }
                                    
                                    if let decimal = option.decimal {
                                        systemCheck = ""
                                        decimal.isSelected = true
                                        decimalConfigurationSaved = decimal.name
                                        handleDecimal(from: decimal)
                                    }
                                    systemCheck = "checkmark"
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .onAppear {
                            systemCheck = "checkmark"
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
            return AnyView(CurrencyView(with: .init(isSelectedAmount: true,
                                            showAmount: true,
                                            currency: currency,
                                            amount: viewModel.amount,
                                                    isBold: viewModel.toggleBoldTextIsOn == true ? .bold : .regular,
                                                    fontSize: viewModel.fontSize)))
        }
        
        if let appearance = model.appearance {
            viewModel.checkIfThemeIsStored(with: selectedTheme,
                                           themeName: appearance.name,
                                           option: appearance)
            if appearance.isSelected == true {
                changeThemeSystem(from: model.appearance)
                return AnyView(selectedViewConfiguration(with: model.appearance?.name ?? ""))
            }
            return AnyView(Text(model.appearance?.name ?? ""))
        }
        
        if let textSection = model.text {
            if textSection.systemSizeToggle == true {
                return AnyView(toggleSizeViewConfiguration(with: textSection.name,
                                                           isOn: viewModel.$toggleSizeIsOn))
            }
            if textSection.boldTextToggle == true {
                return AnyView(toggleViewConfiguration(with: textSection.name,
                                                       isOn: viewModel.$toggleBoldTextIsOn))
            }
        }
        
        if let decimal = model.decimal {
            viewModel.checkIfDecimalWasStored(with: decimalConfigurationSaved,
                                              decimalConfiguration: decimal.name,
                                              option: decimal)
            if decimal.isSelected == true {
                handleDecimal(from: decimal)
                return AnyView(selectedViewConfiguration(with: decimal.name))
            }
            return AnyView(Text(decimal.name))
        }
        return AnyView(Text(model.text?.name ?? ""))
    }
    
    func selectedViewConfiguration(with name: String) -> some View {
        return HStack {
            Text(name)
            Spacer()
            Image(systemName: systemCheck)
                .foregroundColor(.green)
        }
    }
    
    func toggleViewConfiguration(with name: String, isOn: Binding<Bool>) -> some View {
        return HStack {
            Toggle(isOn: isOn) {
                Text(name)
            }
        }
    }
    
    func toggleSizeViewConfiguration(with name: String, isOn: Binding<Bool>) -> some View {
        return VStack {
            Toggle(isOn: isOn) {
                Text(name)
            }
            .onChange(of: viewModel.toggleSizeIsOn, perform: { value in
                if value == false {
                    viewModel.fontSize = 14
                }
            })
            if viewModel.toggleSizeIsOn == true {
                HStack {
                    Text("A")
                        .font(.system(size: 10))
                    Slider(value: viewModel.$fontSize, in: 6...32, step: 5)
                        .padding()
                        .accentColor(Color.green)
                    Text("A")
                }
                
            }
        }
    }
    
    func changeThemeSystem(from option: DisplaySettingAppeareance?) {
        switch DisplaySettingViewModel.Options.Appeareance(rawValue: option?.name ?? "") {
        case .system:
            UIApplication.shared.keyWindow?.overrideUserInterfaceStyle = UITraitCollection().userInterfaceStyle
        case .dark:
            let keyWindow = UIApplication.shared.windows.first(where: \.isKeyWindow)
            keyWindow?.overrideUserInterfaceStyle = .dark
        case .light:
            let keyWindow = UIApplication.shared.windows.first(where: \.isKeyWindow)
            keyWindow?.overrideUserInterfaceStyle = .light
        default: break
        }
        print(UITraitCollection().userInterfaceStyle)
    }
    
    func handleDecimal(from optionValue: DisplaySettingDecimal) {
        switch DisplaySettingViewModel.Options.Decimal.init(rawValue: optionValue.name) {
        case .noDigitMax:
            viewModel.amount.minimunDecimal = .zero
        case .two:
            viewModel.amount.minimunDecimal = .two
        case .three:
            viewModel.amount.minimunDecimal = .three
        case .four:
            viewModel.amount.minimunDecimal = .four
        case .five:
            viewModel.amount.minimunDecimal = .five
        default: break
        }
    }
}

struct DisplaySetting_Previews: PreviewProvider {
    static var previews: some View {
        DisplaySetting()
    }
}
