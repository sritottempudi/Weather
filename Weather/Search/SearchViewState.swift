//
//  SearchViewState.swift
//  Weather
//
//  Created by Srinivasa Tottempudi on 6/9/23.
//

import Foundation

/// View State that defines the Search view current state.
enum SearchViewState {
    case landingScreen
    case noResults(String)
    case dataFetched
    case error
}
