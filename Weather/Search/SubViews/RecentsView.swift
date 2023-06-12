//
//  RecentsView.swift
//  Weather
//
//  Created by Meenamadhuri Ankam on 6/11/23.
//

import SwiftUI

struct RecentsView: View {
    
    var weatherInfo: [WeatherInfo]
    var didTapAction: (WeatherInfo) -> Void
    
    var body: some View {
        if weatherInfo.count == 0 {
            MessageView(message: "Search City for Weather info")
        }
        else {
            List(weatherInfo) { value in
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(LinearGradient(gradient: Gradient(colors: [Color.green, Color.blue]), startPoint: .topLeading, endPoint: .bottomTrailing))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.horizontal, 4)
                        .shadow(color: Color.black, radius: 3, x: 3, y: 3)
                    WeatherTile(weatherInfo: value)
                }
                .modifier(ClearView())
                .onTapGesture {
                    didTapAction(value)
                }
            }
            .listRowBackground(Color.clear)
            .scrollContentBackground(.hidden)
            .padding([.leading, .trailing], -14)
        }
    }
}
