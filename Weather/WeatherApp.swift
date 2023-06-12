//
//  WeatherApp.swift
//  Weather
//
//  Created by Srinivasa Tottempudi on 6/9/23.
//

import SwiftUI

@main
struct WeatherApp: App {
    var body: some Scene {
        WindowGroup {
            SearchView(viewModel: .init(api: NetworkService()))
        }
    }
}
