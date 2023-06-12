//
//  WeatherDetailsView.swift
//  Weather
//
//  Created by Srinivasa Tottempudi on 6/10/23.
//

import SwiftUI

struct WeatherDetailsView<ViewModel>: View where ViewModel: WeatherDetailsViewModelable {
    
    @ObservedObject var viewModel: ViewModel
    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Dismiss")
                        .font(.largeTitle)
                }
                .padding(.all)
            }
            switch viewModel.viewState {
            case .loading:
                Text("Loading")
                    .onAppear {
                        viewModel.fetchWeatherInfo()
                    }
            case .error:
                Text("Error")
            case .success(let weatherInfo):
                WeatherViewSwiftUI(weatherInfo: weatherInfo)
            }
        }
        .edgesIgnoringSafeArea(.all)
        .background(
            ZStack {
                Image("detailsBackground")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
            }
        )
    }
}
