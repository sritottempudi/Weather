//
//  Constants.swift
//  Weather
//
//  Created by Srinivasa Tottempudi on 6/10/23.
//

import Foundation
import Combine

struct Constants {
    
    struct URL {
        static let geoLocationURL = "https://api.openweathermap.org/geo/1.0/direct"
        static let weatherURL = "https://api.openweathermap.org/data/2.5/weather"
    }
    
    struct Params {
        static let lat = "lat"
        static let lon = "lon"
        static let appid = "appid"
        static let appKey = "92cc2da91507c283e09d3ec45f8d5fb2"
    }
}
