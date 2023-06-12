//
//  Double+Temp.swift
//  Weather
//
//  Created by Meenamadhuri Ankam on 6/11/23.
//

import Foundation

extension Double {
    
    var fahrenheit: String {
        let formatter = MeasurementFormatter()
        formatter.unitOptions = .providedUnit
        formatter.numberFormatter.maximumFractionDigits = 0
        let t = Measurement(value: self, unit: UnitTemperature.kelvin)
        return formatter.string(from: t.converted(to: .fahrenheit))
    }
}
