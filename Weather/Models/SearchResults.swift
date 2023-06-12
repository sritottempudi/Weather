//
//  SearchResults.swift
//  Weather
//
//  Created by Srinivasa Tottempudi on 6/9/23.
//

import Foundation

struct SearchResults: Codable {
    let coordinates: [Coordinates]
}

struct Coordinates: Codable, Identifiable {
    let id: UUID = UUID()
    let name: String
    let localNames: [String: String]?
    let lat, lon: Double
    let country: String
    let state: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case localNames = "local_names"
        case lat
        case lon
        case country
        case state
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try container.decode(String.self, forKey: .name)
        localNames = try? container.decodeIfPresent([String: String].self, forKey: .localNames)
        lat = try container.decode(Double.self, forKey: .lat)
        lon = try container.decode(Double.self, forKey: .lon)
        country = try container.decode(String.self, forKey: .country)
        state = try container.decode(String.self, forKey: .state)
    }
    
    init() {
        name = "London"
        localNames = [:]
        lat = 1
        lon = 1
        country = "GB"
        state = "England"
    }
}
