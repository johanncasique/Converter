//
//  HomeConfigurator.swift
//  Converter (iOS)
//
//  Created by johann casique on 6/12/22.
//

import SwiftUI

struct HomeConfigurator {
    @MainActor func setup() -> some View {
        let router = HomeRouter()
        let repository = CurrenciesDataSourceRepository()
        let viewModel = HomeViewModel(router: router,
                                      repository: repository)
        return HomeView(viewModel: viewModel)
    }
}
