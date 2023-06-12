//
//  SearchViewState.swift
//  Weather
//
//  Created by Srinivasa Tottempudi on 6/9/23.
//

import Foundation

/// View State that defines the Search view current state.
enum SearchViewState {
    // Launch screen with Recents data(Previously selected City and Current Location)
    case landingScreen
    // No cities with the current search string
    case noResults(String)
    // Available cities with location info
    case dataFetched
    // Error fetching data
    case error
}
