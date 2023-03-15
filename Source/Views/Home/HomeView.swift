//
//  CurrencyView.swift
//  Shared
//
//  Created by johann casique on 26/9/21.
//

import SwiftUI

struct HomeView: View {
    
    @ObservedObject var viewModel: HomeViewModel
    let slashPlusImage = "minus.slash.plus"
    let navigationTitleText = "Currency"
    @State private var country: CountryModelDTO!
    @State private var isPresented: Bool = false
    
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
    }
}
// MARK: - Bar Item Views
extension HomeView {
    private var toolBarItemView: some View {
        HStack {
            addCountryBarItemView
            Spacer()
            editBarItemView
        }.padding(.horizontal, -5)
    }
    
    private var addCountryBarItemView: some View {
        Button(action: { viewModel.isShowingAddCountry.toggle() }) {
            Image(systemName: "plus")
        }
        .sheet(isPresented: $viewModel.isShowingAddCountry) {
            AddCurrencyConfigurator().setup(
                isPresented: $viewModel.isShowingAddCountry,
                countrySelection: $viewModel.countrySelected
            )
            .navigationBarTitle("Agregar moneda")
        }
    }
    
    private var editBarItemView: some View {
        Button("Edit") {
            print("Click button")
        }
    }
}


// MARK: - Main views
extension HomeView {
    private var mainView: some View {
        countryList
            .navigationTitle(navigationTitleText)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    toolBarItemView
                }
            }
    }
    
    private var countryList: some View {
        List(viewModel.countrySelected, id: \.id) { countrySelected in
            countrySelectionButtonCell(countrySelected)
        }
    }
    
    private func countrySelectionButtonCell(_ countrySelected: CountryModel) -> some View {
        let onTap = TapGesture()
                .onEnded {
                    self.country = countrySelected.getDTO()
                    viewModel.isShowingCalculator.toggle()
                }

            return currencyView(with: countrySelected.getDTO())
                .padding(4)
                .listRowSeparator(.hidden)
                .gesture(onTap)
                .sheet(isPresented: $viewModel.isShowingCalculator) {
                    CalculatorView(isPresented: $viewModel.isShowingCalculator,
                                   customAmount: $viewModel.amountSelected,
                                   countryDO: country)

                }
    }

    func currencyView(with model: CountryModelDTO) -> some View {
        CurrencyView(with: viewModel.currencyViewModel(with: model))
    }
}
