//
//  HomeConfigurator.swift
//  Converter (iOS)
//
//  Created by johann casique on 6/12/22.
//

import SwiftUI

struct HomeConfigurator {
    @MainActor func setup() -> some View {
        let repository = CurrenciesDataSourceRepository(configure: AppConfig.apiConfig())
        let viewModel = HomeViewModel(repository: repository)
        return HomeView(viewModel: viewModel)
    }
}
