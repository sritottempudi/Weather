//
//  MessageView.swift
//  Weather
//
//  Created by Meenamadhuri Ankam on 6/11/23.
//

import SwiftUI

struct MessageView: View {
    
    var message: String
    
    var body: some View {
        VStack {
            Spacer()
            Text(message)
                .fontWeight(.bold)
                .font(.callout)
            Spacer()
        }
    }
}
