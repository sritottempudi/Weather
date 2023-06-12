//
//  BottomSheet.swift
//  Weather
//
//  Created by Meenamadhuri Ankam on 6/11/23.
//

import SwiftUI

struct BottomSheet<ViewModel>: View where ViewModel: SearchViewModelable {
    
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        WeatherDetailsView(viewModel: weatherDetailsViewModel)
    }
    
    var weatherDetailsViewModel: WeatherDetailsViewModel {
        switch viewModel.viewState {
        case .landingScreen:
            return .init(api: viewModel.api,
                         weatherInfo: viewModel.selectedCityWeatherInfo)
        case .dataFetched:
            return .init(api: viewModel.api,
                         selectedCity: viewModel.selectedCity)
        default:
            return .init(api: viewModel.api,
                         weatherInfo: nil)
        }
    }
}
