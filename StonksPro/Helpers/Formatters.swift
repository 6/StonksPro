//
//  Formatters.swift
//  StonksPro
//
//  Created by Peter Graham on 6/26/23.
//

import Foundation
import SwiftUI

let maxDecimalsForPercent = 2

func formatPercent(percent: Float) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .percent
    formatter.minimumIntegerDigits = 1
    formatter.maximumIntegerDigits = 3
    formatter.minimumFractionDigits = maxDecimalsForPercent
    formatter.maximumFractionDigits = maxDecimalsForPercent
    formatter.locale = Locale(identifier: "en_US")
    var result = formatter.string(from: NSNumber(value: percent / 100)) ?? ""
    if percent.roundToDecimal(maxDecimalsForPercent) >= 0 {
        result = "+" + result
    }
    return result
}

func textColorForPercent(percent: Float) -> Color {
    if percent.roundToDecimal(maxDecimalsForPercent) > 0 {
        return Color.green
    } else if percent.roundToDecimal(2) < 0 {
        return Color(red: 1.0, green: 0.5, blue: 0.5)
    } else {
        return Color.gray
    }
}
