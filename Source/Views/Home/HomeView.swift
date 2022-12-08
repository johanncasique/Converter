//
//  CurrencyView.swift
//  Shared
//
//  Created by johann casique on 26/9/21.
//

import SwiftUI

struct HomeView: View {
    
    @ObservedObject var viewModel: HomeViewModel
    @ObservedObject private var countries = Countries()
    let slashPlusImage = "minus.slash.plus"
    
    var body: some View {
        NavigationView {
            switch viewModel.viewState {
            case .loading:
                Text("Loading")
            case .loaded:
                mainView
            case .error, .none:
                Text("ERROR")
            }
        }
        .navigationViewStyle(.stack)
        .toolbar {
            AnyView(Image(systemName: slashPlusImage))
        }
    }
    
    
    private var mainView: some View {
        VStack {
            List {
                ForEach(viewModel.selectionCountry, id: \.self) { countrySelected in
                    presentCalculatorButton(with: countrySelected)
                }
            }
            .navigationTitle(Text("Currency"))
            .toolbar {
                ToolbarItem(placement: .principal) {
                    toolBarItemView
                }
            }
        }
    }
    
    private var headerView: some View {
        HStack(alignment: .top) {
            Text("Currency")
                .foregroundColor(.primary)
                .font(Font.system(.largeTitle).bold())
            Spacer()
        }
        .padding(.horizontal, 16)
    }
    
    private var toolBarItemView: some View {
        HStack {
            Button(action: { viewModel.isShowingAddCountry.toggle() }) {
                Image(systemName: "plus")
            }
            .sheet(isPresented: $viewModel.isShowingAddCountry) {
                    addCurrencyView()
                    .navigationBarTitle("Agregar moneda")
            }
            Spacer()
            Button("Edit") {
                print("Click button")
            }
        }.padding(.horizontal, -5)
    }
    
    func presentCalculatorButton(with country: CountryModel) -> some View {
        Button {
            viewModel.isShowingCalculator.toggle()
        } label: {
            currencyView(with: country)
            .padding(4)
            .listRowSeparator(.hidden)
        }
        .sheet(isPresented: $viewModel.isShowingCalculator) {
            addCalculatorView()
        }
    }
    
    private func addCurrencyView() -> some View {
        AddCurrencyView(isPresented: $viewModel.isShowingAddCountry,
                        countrySelection: $viewModel.selectionCountry)
    }
    
    private func addCalculatorView() -> some View {
        CalculatorView(isPresented: $viewModel.isShowingCalculator,
                       customAmount: $viewModel.amountSelected)
    }
    
    func selectedCountriesData() -> String {
        return "\(viewModel.selectionCountry.count)"
    }
    
    func currencyView(with model: CountryModel) -> some View {
        CurrencyView(with: viewModel.currencyViewModel(with: model))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HomeView(viewModel: .init(repository: .init(configure: AppConfig.apiConfig())))
            HomeView(viewModel: .init(repository: .init(configure: AppConfig.apiConfig())))
                .preferredColorScheme(.dark)
        }
    }
} 
