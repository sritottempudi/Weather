//
//  WeatherViewRepresentable.swift
//  Weather
//
//  Created by Srinivasa Tottempudi on 6/11/23.
//

import SwiftUI

struct WeatherViewSwiftUI: UIViewRepresentable {

    var weatherInfo: WeatherInfo
    
    func makeUIView(context: Context) -> WeatherView {
        let view = WeatherView()
        view.backgroundColor = .clear
        view.update(weatherInfo: weatherInfo)
        return view
    }

    func updateUIView(_ uiView: WeatherView, context: Context) {
        uiView.update(weatherInfo: weatherInfo)
    }
}
