//
//  WeatherDetailsViewModel.swift
//  Weather
//
//  Created by Srinivasa Tottempudi on 6/10/23.
//

import Foundation
import Combine

protocol WeatherDetailsViewModelable: ObservableObject {
    var viewState: WeatherViewState { get set }
    func fetchWeatherInfo()
}


class WeatherDetailsViewModel: ObservableObject, WeatherDetailsViewModelable {

    @Published var viewState: WeatherViewState = .loading
    private var selectedCity: Coordinates?
    private var anyCancellable = Set<AnyCancellable>()
    private var api: NetworkServicable

    init(api: NetworkServicable, selectedCity: Coordinates?) {
        self.api = api
        self.selectedCity = selectedCity
    }
    
    init(api: NetworkServicable, weatherInfo: WeatherInfo?) {
        self.api = api
        if let weatherInfo = weatherInfo {
            self.viewState = .success(data: weatherInfo)
        }
        else {
            viewState = .error
        }
    }
    
    
    func fetchWeatherInfo() {
        guard let selectedCity = selectedCity else {
            viewState = .error
            return
        }
        let coordinates = LocationCoordinates(lat: selectedCity.lat, lon: selectedCity.lon)
        api.fetchWeatherInfo(coordinates)
            .sink(receiveCompletion: { (completion) in
                switch completion {
                case .failure:
                    self.viewState = .error
                case .finished:
                    break
                }
            }) { [self] result in
                self.viewState = .success(data: result)
            }
            .store(in: &anyCancellable)
    }

}

enum WeatherViewState {
    case loading
    case success(data: WeatherInfo)
    case error
}

