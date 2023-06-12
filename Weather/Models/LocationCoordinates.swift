//
//  LocationCoordinates.swift
//  Weather
//
//  Created by Srinivasa Tottempudi on 6/11/23.
//

import Foundation

struct LocationCoordinates: Codable, Identifiable {
    let id: UUID = UUID()
    let lat, lon: Double
    
    enum CodingKeys: String, CodingKey {
        case lat
        case lon
    }
}
