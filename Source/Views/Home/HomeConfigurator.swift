//
//  HomeConfigurator.swift
//  Converter (iOS)
//
//  Created by johann casique on 6/12/22.
//

import SwiftUI

struct HomeConfigurator {
    @MainActor func setup() -> some View {
        let repository = ExchangeRatesDataSourceRepository()
        let dbRepository = ExchangeRatesDBRepository()
        let viewModel = HomeViewModel(repository: repository,
                                      dbRepository: dbRepository)
        return HomeView(viewModel: viewModel)
    }
}
