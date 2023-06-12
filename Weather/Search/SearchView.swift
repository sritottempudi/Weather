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
        VStack(alignment: .center, spacing: 0) {
            
            Text("Weather")
                .font(.largeTitle)
                .bold()

            searchTextView
            
            Spacer()
            
            switch viewModel.viewState {
            case .landingScreen:
                RecentsView(weatherInfo: viewModel.landingScreenInfo) {
                    viewModel.didSelectCity(weatherInfo: $0)
                }
                .onAppear {
                    viewModel.onAppear()
                }
            case .dataFetched:
                ResultsListView(coordinates: viewModel.renderModel) {
                    viewModel.didSelectCity(coordinates: $0)
                }
            case .error:
                MessageView(message: "Error fetching data")
            case let .noResults(searchText):
                MessageView(message: "No Results for \(searchText)")
            }
        }
        .background(backgroundImageView)
        .sheet(isPresented: $viewModel.showDetailsView) {
            BottomSheet(viewModel: viewModel)
        }
        
    }
    
    var searchTextView: some View {
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
    }
    
    var backgroundImageView: some View {
        ZStack {
            Image("detailsBackground")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
        }
    }
}
