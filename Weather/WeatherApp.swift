//
//  WeatherApp.swift
//  Weather
//
//  Created by Srinivasa Tottempudi on 6/9/23.
//

import SwiftUI

@main
struct WeatherApp: App {
    
    @StateObject var viewModel: SearchViewModel = .init(api: NetworkService())
    
    var body: some Scene {
        WindowGroup {
            SearchView(viewModel: viewModel)
        }
    }
}
