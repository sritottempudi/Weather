//
//  BottomSheet.swift
//  Weather
//
//  Created by Meenamadhuri Ankam on 6/11/23.
//

import SwiftUI

struct BottomSheet: View {
    
    @ObservedObject var viewModel: SearchViewModel
    
    var body: some View {
        switch viewModel.viewState {
        case .landingScreen:
            return WeatherDetailsView(viewModel: .init(api: viewModel.api,
                                                weatherInfo: viewModel.selectedCityWeatherInfo))
        case .dataFetched:
            return WeatherDetailsView(viewModel: .init(api: viewModel.api,
                                                selectedCity: viewModel.selectedCity))
        default:
            return WeatherDetailsView(viewModel: .init(api: viewModel.api,
                                                weatherInfo: nil))
        }
    }
}
