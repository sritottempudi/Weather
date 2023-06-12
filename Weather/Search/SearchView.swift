//
//  SearchView.swift
//  Weather
//
//  Created by Srinivasa Tottempudi on 6/9/23.
//

import SwiftUI

struct SearchView: View {

    @ObservedObject var viewModel: SearchViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center, spacing: 0) {
                ZStack {
                    Color.black.opacity(0.3)
                    HStack {
                        TextField("Search", text: $viewModel.searchString)
                            .padding([.leading, .trailing], 6)
                            .frame(height: 30)
                            .background(Color.white.opacity(0.4))
                            .cornerRadius(15)
                    }
                    .padding([.leading, .trailing], 14)
                }.frame(height: 60)
                
                Spacer()
                
                switch viewModel.viewState {
                case .error:
                    VStack {
                        Spacer()
                        Text("Error fetching data")
                            .fontWeight(.bold)
                            .font(.callout)
                        Spacer()
                    }
                case let .noResults(searchText):
                    VStack {
                        Spacer()
                        Text("No Results for \(searchText)")
                            .fontWeight(.bold)
                            .font(.callout)
                        Spacer()
                    }
                case .landingScreen:
                    List(viewModel.landingScreenInfo) { value in
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(LinearGradient(gradient: Gradient(colors: [Color.green, Color.blue]), startPoint: .topLeading, endPoint: .bottomTrailing))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .padding(.horizontal, 4)
                                .shadow(color: Color.black, radius: 3, x: 3, y: 3)
                            WeatherTile(weatherInfo: value)
                        }
                        .modifier(ClearCell())
                        .onTapGesture {
                            viewModel.didSelectCity(weatherInfo: value)
                        }
                    }
                    .listRowBackground(Color.clear)
                    .scrollContentBackground(.hidden)
                    .padding([.leading, .trailing], -14)
                    .onAppear {
                        viewModel.onAppear()
                    }
                case .dataFetched:
                    List(viewModel.renderModel) { value in
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(LinearGradient(gradient: Gradient(colors: [Color.green, Color.blue]), startPoint: .topLeading, endPoint: .bottomTrailing))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .padding(.horizontal, 4)
                                .shadow(color: Color.black, radius: 3, x: 3, y: 3)
                            HStack {
                                SearchTile(city: value)
                                Spacer()
                            }
                        }
                        .modifier(ClearCell())
                        .onTapGesture { _ in
                            viewModel.didSelectCity(coordinates: value)
                        }
                    }
                    .listRowBackground(Color.clear)
                    .scrollContentBackground(.hidden)
                }
            }
            .background(
                ZStack {
                    Image("detailsBackground")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .edgesIgnoringSafeArea(.all)
                }
            )
            .sheet(isPresented: $viewModel.showDetailsView) {
                switch viewModel.viewState {
                case .landingScreen:
                    WeatherDetailsView(viewModel: .init(api: viewModel.api,
                                                        weatherInfo: viewModel.selectedCityWeatherInfo))
                case .dataFetched:
                    WeatherDetailsView(viewModel: .init(api: viewModel.api,
                                                        selectedCity: viewModel.selectedCity))
                default:
                    EmptyView()
                }
            }
            .navigationBarTitle(Text("Weather"))
        }
        
    }
    
    func weatherDetailsView(selectedCity: Coordinates) -> WeatherDetailsView {
        WeatherDetailsView(viewModel: .init(api: viewModel.api,
                                            selectedCity: selectedCity))
    }
}

struct ClearCell: ViewModifier {
      func body(content: Content) -> some View {
          content
              .font(.system(size: 18, weight: .bold, design: .rounded))
              .foregroundColor(.black)
              .listRowBackground(Color.clear)
      }
  }
