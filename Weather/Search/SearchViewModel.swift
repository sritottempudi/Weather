//
//  SearchViewModel.swift
//  Weather
//
//  Created by Srinivasa Tottempudi on 6/9/23.
//

import Foundation
import Combine
import CoreLocation

protocol SearchViewModelable: ObservableObject {
    // Search results with city names and its coordinates
    var results: [Coordinates] { get set }
    // User searched string
    var searchString: String { get set }
    // Search view states
    var viewState: SearchViewState { get set }
    // Boolean to show/hide the details view when tapped on tiles
    var showDetailsView: Bool { get set }
    // City selected by the user after search results
    var selectedCity: Coordinates? { get set }
    // City selected by user in the recents page
    var selectedCityWeatherInfo: WeatherInfo? { get set }
    // Netowrk servicable that has the instance to make network calls
    var api: NetworkServicable { get set }
    // Landing page with recently selected city and current location details
    var landingScreenInfo: [WeatherInfo] { get set }
    
    // Recents screen onAppear
    func onAppear()
    // User selected city on the resutls screen
    func didSelectCity(coordinates: Coordinates)
    // User selected city on the recents screen
    func didSelectCity(weatherInfo: WeatherInfo)
}

class SearchViewModel: ObservableObject, SearchViewModelable {
    var results: [Coordinates] = []
    @Published var searchString = ""
    @Published var viewState: SearchViewState = .landingScreen
    @Published var showDetailsView: Bool = false
    var selectedCity: Coordinates?
    var selectedCityWeatherInfo: WeatherInfo?
    var api: NetworkServicable
    @Published var landingScreenInfo: [WeatherInfo] = []
    
    // Local variable that updates the search landing screen data
    private var currentLocationWeatherInfo: WeatherInfo? {
        didSet {
            self.appendLandingScreenWeatherInfo()
        }
    }
    // Local variable that updates the search landing screen data
    private var previouslySearchedWeatherInfo: WeatherInfo? {
        didSet {
            self.appendLandingScreenWeatherInfo()
        }
    }
    private var anyCancellable = Set<AnyCancellable>()
    
    init(api: NetworkServicable) {
        self.api = api
        subscribeSearchResults()
    }
    
    func onAppear() {
        fetchSavedData()
        retrieveCurrentLocation()
    }
    
    // User selected city on the resutls screen
    func didSelectCity(coordinates: Coordinates) {
        self.selectedCity = coordinates
        selectedCityWeatherInfo = nil
        showDetailsView = true
        saveDataInCache()
    }
    
    // User selected city on the recents screen
    func didSelectCity(weatherInfo: WeatherInfo) {
        selectedCityWeatherInfo = weatherInfo
        selectedCity = nil
        showDetailsView = true
        saveDataInCache()
    }
}

extension SearchViewModel {
    /// Subscribe for search text changes and fetch search results
    private func subscribeSearchResults() {
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
    
    ///  Saving data to cache
    private func saveDataInCache() {
        UserDefaults.standard.storeCodable(selectedCity, key: "SelectedCity")
        UserDefaults.standard.storeCodable(selectedCityWeatherInfo, key: "SelectedWeatherInfo")
    }
}
extension SearchViewModel: LocationManagerDelegate {
    /// Callback for did change location authorization status
    /// - Parameters:
    ///   - status: Location authorization status
    ///   - location: current location
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
    
    /// Fetches search results
    /// - Parameter searchText: user entered text
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
                    self.results = result
                    self.viewState = .dataFetched
                }
            }
            .store(in: &anyCancellable)
    }
    
    /// Fetch weather info for the given location coordinates
    /// - Parameters:
    ///   - location: Lat and Lon of the location
    ///   - completion: return the weather info if available
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
    
    /// Fetches the initial launch data from cache/location manager
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



