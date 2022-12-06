//
//  SettingsView.swift
//  Converter (iOS)
//
//  Created by johann casique on 13/7/22.
//

import SwiftUI

struct SettingsView: View {
    
    @State var viewModel = SettingsViewModel.settings
    @State private var locationIsOn = false
    @State private var keypadSoundIsOn = false
    @State private var inverseIsOn = false
    
    var body: some View {
        
        NavigationView {
            List {
                ForEach(viewModel) { options in
                    Section(footer: Text(options.footer ?? "")) {
                        ForEach(options.options) { optionType in
                            
                            if optionType.goTodetail {
                                if optionType.subtitle != nil {
                                    NavigationLink {
                                        DisplaySetting()
                                    } label: {
                                        option(with: optionType)
                                    }
                                } else {
                                    NavigationLink(optionType.name) {
                                        goToDetail(optionType)
                                    }
                                }
                                
                            } else {
                                checkButtonConfig(to: optionType)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
    
    func checkButtonConfig(to optionType: SettingType) -> some View {
        
        switch SettingsViewModel.Name.init(rawValue: optionType.name) {
        case .location:
            return AnyView(Toggle(optionType.name, isOn: $locationIsOn))
        case .keypadSound:
            return AnyView(Toggle(optionType.name, isOn: $keypadSoundIsOn))
        case .inverse:
            return AnyView(Toggle(optionType.name, isOn: $inverseIsOn))
        default:
            return  AnyView(Text(""))
        }
    }
    
    func option(with optionType: SettingType) -> some View {
        Label {
            Text(optionType.name)
            Spacer()
            Text(optionType.subtitle ?? "")
                .foregroundColor(.gray)
        } icon: {
            
        }
    }
    
    func goToDetail(_ option: SettingType) -> some View {
        switch SettingsViewModel.Name.init(rawValue: option.name) {
        case .display: return AnyView(DisplaySetting())
        default: return AnyView(Text("Hello"))
        }
    }
    
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
