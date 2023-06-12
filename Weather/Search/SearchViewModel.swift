//
//  SearchViewModel.swift
//  Weather
//
//  Created by Srinivasa Tottempudi on 6/9/23.
//

import Foundation
import Combine
import CoreLocation

class SearchViewModel: ObservableObject {

    var renderModel: [Coordinates] = []
    @Published var searchString = ""
    @Published var viewState: SearchViewState = .landingScreen
    @Published var showDetailsView: Bool = false
    var selectedCity: Coordinates?
    var selectedCityWeatherInfo: WeatherInfo?
    private var currentLocationWeatherInfo: WeatherInfo? {
        didSet {
            self.appendLandingScreenWeatherInfo()
        }
    }
    private var previouslySearchedWeatherInfo: WeatherInfo? {
        didSet {
            self.appendLandingScreenWeatherInfo()
        }
    }
    @Published var landingScreenInfo: [WeatherInfo] = []
    
    private var anyCancellable = Set<AnyCancellable>()

    var api: NetworkServicable

    init(api: NetworkServicable) {
        self.api = api
        subscribeSearchResults()
    }
    
    func onAppear() {
        fetchSavedData()
        retrieveCurrentLocation()
    }
    
    func didSelectCity(coordinates: Coordinates) {
        self.selectedCity = coordinates
        selectedCityWeatherInfo = nil
        showDetailsView = true
        saveDataInCache()
    }
    
    func didSelectCity(weatherInfo: WeatherInfo) {
        selectedCityWeatherInfo = weatherInfo
        selectedCity = nil
        showDetailsView = true
        saveDataInCache()
    }
}

extension SearchViewModel {
    func subscribeSearchResults() {
        $searchString
            .debounce(for: 1.0, scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { result in
                if result.isEmpty {
                    self.viewState = .landingScreen
                }
                else {
                    self.getSearchResults(for: result)
                }
            }.store(in: &anyCancellable)
    }
    
    func saveDataInCache() {
        UserDefaults.standard.storeCodable(selectedCity, key: "SelectedCity")
        UserDefaults.standard.storeCodable(selectedCityWeatherInfo, key: "SelectedWeatherInfo")
    }
}
extension SearchViewModel: LocationManagerDelegate {
    func didChangeAuthorization(status: CLAuthorizationStatus, location: CLLocation?) {
        guard let location = location else {
            return
        }
        fetchWeather(location: .init(lat: location.coordinate.latitude,
                                     lon: location.coordinate.longitude), completion: { [weak self] in
            self?.currentLocationWeatherInfo = $0
        })
    }
}

extension SearchViewModel {

    private func getSearchResults(for searchText: String) {
        api.searchCity(searchText)
            .sink(receiveCompletion: { (completion) in
                switch completion {
                case .failure:
                    self.viewState = .error
                case .finished:
                    break
                }
            }) { [self] result in

                if result.count == 0 {
                    self.viewState = .noResults(searchText)
                }
                else {
                    self.renderModel = result
                    self.viewState = .dataFetched
                }
            }
            .store(in: &anyCancellable)
    }
    
    private func fetchWeather(location: LocationCoordinates, completion: @escaping ((WeatherInfo?) -> Void)) {
        api.fetchWeatherInfo(location)
            .sink(receiveCompletion: { (completion) in
                switch completion {
                case .failure:
                    break
                case .finished:
                    break
                }
            }) { result in
                completion(result)
            }
            .store(in: &anyCancellable)
    }
    
    private func appendLandingScreenWeatherInfo() {
        var landingScreenData: [WeatherInfo] = []
        if let previouslySearchedWeatherInfo = previouslySearchedWeatherInfo {
            landingScreenData.append(previouslySearchedWeatherInfo)
        }
        if let currentLocationWeatherInfo = currentLocationWeatherInfo,
           currentLocationWeatherInfo.id != previouslySearchedWeatherInfo?.id {
            landingScreenData.append(currentLocationWeatherInfo)
        }
        self.landingScreenInfo = landingScreenData
    }
    
    private func fetchSavedData() {
        let savedWeatherInfo : WeatherInfo? = UserDefaults.standard.retrieveCodable(for: "SelectedWeatherInfo")
        let savedSelectedCity: Coordinates? = UserDefaults.standard.retrieveCodable(for: "SelectedCity")
        if let selectedCity = selectedCity ?? savedSelectedCity {
            fetchWeather(location: .init(lat: selectedCity.lat, lon: selectedCity.lon)) { [weak self] in
                self?.previouslySearchedWeatherInfo = $0
            }
        }
        else if let weatherInfo = savedWeatherInfo {
            currentLocationWeatherInfo = weatherInfo
        }
    }
    
    private func retrieveCurrentLocation() {
        if let location = LocationManager.shared.currentLocation() {
            fetchWeather(location: .init(lat: location.coordinate.latitude,
                                         lon: location.coordinate.longitude), completion: { [weak self] in
                self?.currentLocationWeatherInfo = $0
            })
        } else {
            DispatchQueue.main.async {
                LocationManager.shared.requestLocationAuthorization()
                LocationManager.shared.delegate = self
            }
        }
    }
}

enum SomeError: Error {
    case incorrectOuput
}



