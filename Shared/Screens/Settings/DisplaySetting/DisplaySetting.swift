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
    @State private var toggleSizeIsOn = false
    @State private var toggleBoldTextIsOn = false
    @ObservedObject var amount = Amount(value: 9756.89879)
    @State private var textSize = 14.0
    @State private var showDetail = false

    
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
                                    option.appearance?.isSelected = true
                                    systemCheck = "checkmark"
                                    if let decimal = option.decimal {
                                        handleDecimal(from: decimal)
                                    }
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
            return AnyView(CurrencyModelView(currency: currency,
                                             showAmount: true,
                                             amount: amount,
                                             isBold: toggleBoldTextIsOn == true ? .bold : .regular,
                                             fontSize: textSize))
        }
        
        if  model.appearance != nil {
            if model.appearance?.isSelected == true {
                changeThemeSystem(from: model.appearance)
                return AnyView(selectedViewConfiguration(with: model.appearance?.name ?? ""))
            }
            return AnyView(Text(model.appearance?.name ?? ""))
        }
        
        if let textSection = model.text {
            if textSection.systemSizeToggle == true {
                return AnyView(toggleSizeViewConfiguration(with: textSection.name, isOn: $toggleSizeIsOn))
            }
            if textSection.boldTextToggle == true {
                return AnyView(toggleViewConfiguration(with: textSection.name, isOn: $toggleBoldTextIsOn))
            }
        }
        
        if let decimal = model.decimal {
            if decimal.isSelected == true {
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
            .onChange(of: toggleSizeIsOn, perform: { value in
                if value == false {
                    textSize = 14
                }
            })
            if toggleSizeIsOn == true {
                HStack {
                    Text("A")
                        .font(.system(size: 10))
                    Slider(value: $textSize, in: 6...32, step: 5)
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
        optionValue.isSelected = true
        switch DisplaySettingViewModel.Options.Decimal.init(rawValue: optionValue.name) {
        case .two: amount.minimunDecimal = .two
        case .three: amount.minimunDecimal = .three
        case .four: amount.minimunDecimal = .four
        case .five: amount.minimunDecimal = .five
        default: break
        }
    }
    
//    func changeSystemSize(from option: DisplaySettingOption) {
//        switch DisplaySettingViewModel.Options.TexSize(rawValue: option.name ?? "") {
//        case .system:
//            
//        case .bold:
//        default: break
//        }
//    }
}

struct DisplaySetting_Previews: PreviewProvider {
    static var previews: some View {
        DisplaySetting()
    }
}
