//
//  SearchTile.swift
//  Weather
//
//  Created by Srinivasa Tottempudi on 6/10/23.
//

import Foundation
import SwiftUI

struct SearchTile : View {
    
    var city: Coordinates
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(city.name)
                .lineLimit(nil)
                .font(.title)
            HStack(spacing: 0) {
                Text(city.state)
                    .lineLimit(nil)
                    .font(.caption)
                Text(",")
                    .lineLimit(nil)
                    .font(.caption)
                Text(city.country)
                    .lineLimit(nil)
                    .font(.caption)
            }
        }
        .padding()
    }
}

struct SearchTile_Previews: PreviewProvider {
    static var previews: some View {
        SearchTile(city: .init())
    }
}
