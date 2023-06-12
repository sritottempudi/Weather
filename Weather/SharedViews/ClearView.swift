//
//  ClearView.swift
//  Weather
//
//  Created by Meenamadhuri Ankam on 6/11/23.
//

import SwiftUI

struct ClearView: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 18, weight: .bold, design: .rounded))
            .foregroundColor(.black)
            .listRowBackground(Color.clear)
    }
}
