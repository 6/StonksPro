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
    } else if percent.roundToDecimal(maxDecimalsForPercent) < 0 {
        return Color(red: 1.0, green: 0.5, blue: 0.5)
    } else {
        return Color.gray
    }
}

func formatDollar(value: Float) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.currencySymbol = "$"
    formatter.minimumIntegerDigits = 1
    formatter.minimumFractionDigits = 2
    formatter.maximumFractionDigits = 8
    if value >= 0.99 {
        formatter.maximumFractionDigits = 2
    } else if value >= 0.0099 {
        formatter.maximumFractionDigits = 4
    } else {
        formatter.maximumFractionDigits = 8
    }
    return formatter.string(from: NSNumber(value: value)) ?? ""
}
