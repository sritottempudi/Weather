//
//  WeatherViewRepresentable.swift
//  Weather
//
//  Created by Srinivasa Tottempudi on 6/11/23.
//

import SwiftUI

struct WeatherViewSwiftUI: UIViewRepresentable {

    func makeUIView(context: Context) -> WeatherView {
        let view = WeatherView()
        view.backgroundColor = .clear
        return view
    }

    func updateUIView(_ uiView: WeatherView, context: Context) {

    }
}
