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
