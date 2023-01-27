//
//  HomeConfigurator.swift
//  Converter (iOS)
//
//  Created by johann casique on 6/12/22.
//

import SwiftUI

struct HomeConfigurator {
    
    func setup() -> UIViewController {
        let repository = ExchangeRatesDataSourceRepository(configure: AppConfig.apiConfig())
        let dbRepository = ExchangeRatesDBRepository()
        let viewModel = HomeViewModel(repository: repository,
                                      dbRepository: dbRepository)
        return HomeViewController(homeViewModel: viewModel)
    }
}
