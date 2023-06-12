//
//  ResultsListView.swift
//  Weather
//
//  Created by Meenamadhuri Ankam on 6/11/23.
//

import SwiftUI

struct ResultsListView: View {
    
    var coordinates: [Coordinates]
    var didTapAction: (Coordinates) -> Void
    
    var body: some View {
        List(coordinates) { value in
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
            .modifier(ClearView())
            .onTapGesture { _ in
                didTapAction(value)
            }
        }
        .listRowBackground(Color.clear)
        .scrollContentBackground(.hidden)
    }
}
