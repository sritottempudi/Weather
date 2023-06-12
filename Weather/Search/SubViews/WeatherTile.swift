//
//  WeatherTile.swift
//  Weather
//
//  Created by Srinivasa Tottempudi on 6/10/23.
//

import SwiftUI

struct WeatherTile: View {
    
    var weatherInfo: WeatherInfo
    
    var body: some View {
        HStack(alignment: .center) {
            Text(weatherInfo.name)
                .lineLimit(nil)
                .font(.largeTitle)
            Spacer()
            VStack(spacing: 0) {
                Text(String(weatherInfo.main.temp.fahrenheit))
                HStack {
                    Text("Min")
                    Text(String(weatherInfo.main.tempMin.fahrenheit))
                }
                HStack {
                    Text("Max")
                    Text(String(weatherInfo.main.tempMax.fahrenheit))
                }
            }
            
        }
        .padding()
    }
}
