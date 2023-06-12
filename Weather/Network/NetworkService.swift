//
//  NetworkService.swift
//  Weather
//
//  Created by Srinivasa Tottempudi on 6/9/23.
//

import Foundation
import Combine


/// Network servicable that can be passed around objects/classes
protocol NetworkServicable {
    /// Search method that makes an API call to fetch results
    /// - Parameter searchString: Text that need to be searched.
    /// - Returns: Publisher that emits result object
    func searchCity(_ searchString: String) -> AnyPublisher<[Coordinates], NetworkError>
    func fetchWeatherInfo(_ coordinate: LocationCoordinates) -> AnyPublisher<WeatherInfo, NetworkError>
}


class NetworkService: NetworkServicable {

    struct Response<T> {
        let value: T
        let response: URLResponse
    }
    
    /// URL session requesting and processing the network error and decoding error.
    /// - Parameter request: URL request info that contains additional params and URL information
    /// - Returns: Generic DataModel and Network error that includes Decoder error and network error.
    private func getRequest<T: Decodable>(_ request: URLRequest) -> AnyPublisher<T, NetworkError> {
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .mapError { NetworkError.request(underlyingError: $0) }
            .map { $0.data }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { $0 as? NetworkError ?? .unableToDecode(underlyingError: $0) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    private func fetchData<T: Decodable>(type: RequestType) -> AnyPublisher<T, NetworkError> {
        guard let baseURL = URL(string: type.baseURL),
              var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true) else {
            return Fail(error: NetworkError.badUrl)
                .eraseToAnyPublisher()
        }
        var queryParams: [String: String]
        switch type {
        case .searchCity(let cityName):
            queryParams = ["q": cityName,
                           "limit": "25"]
        case .weatherInfo(let coordinates):
            queryParams = ["lat": String(coordinates.lat),
                           "lon": String(coordinates.lon)]
        }
        
        // Common Parameters
        queryParams["appid"] = "92cc2da91507c283e09d3ec45f8d5fb2"
        
        components.setQueryItems(with: queryParams)

        let request = URLRequest(url: components.url!)

        return getRequest(request)
            .eraseToAnyPublisher()
    }
}

extension NetworkService {
    /// Search method that makes an API call to fetch city names
    /// - Parameter searchString: Text that need to be searched.
    /// - Returns: Publisher that emits [Coordinates] and  NetworkError
    func searchCity(_ searchString: String) -> AnyPublisher<[Coordinates], NetworkError> {
        fetchData(type: .searchCity(name: searchString))
    }
    
    /// Fetches weather info for specified latitude and longitude
    /// - Parameter coordinate: Included lat and long
    /// - Returns: Publisher that emits Weather info and Network Error
    func fetchWeatherInfo(_ coordinate: LocationCoordinates) -> AnyPublisher<WeatherInfo, NetworkError> {
        fetchData(type: .weatherInfo(coordinate: coordinate))
    }
}

enum RequestType {
    case searchCity(name: String)
    case weatherInfo(coordinate: LocationCoordinates)
    
    var baseURL: String {
        switch self {
        case .searchCity:
            return Constants.URL.geoLocationURL
        case .weatherInfo:
            return Constants.URL.weatherURL
        }
    }
}
