//
//  ImmersiveView.swift
//  StonksPro
//
//  Created by Peter Graham on 6/25/23.
//

import SwiftUI
import Charts
import RealityKit
import RealityKitContent

let cheeseburgerCost: [Food] = [
    .init(name: "Cheeseburger", price: 0.15, year: 1960),
    .init(name: "Cheeseburger", price: 0.20, year: 1970),
    // ...
    .init(name: "Cheeseburger", price: 1.10, year: 2020)
]


struct Food: Identifiable {
    let name: String
    let price: Double
    let date: Date
    let id = UUID()


    init(name: String, price: Double, year: Int) {
        self.name = name
        self.price = price
        let calendar = Calendar.autoupdatingCurrent
        self.date = calendar.date(from: DateComponents(year: year))!
    }
}

struct ImmersiveView: View {
    var body: some View {
        Chart(cheeseburgerCost) { cost in
            AreaMark(
                x: .value("Date", cost.date),
                y: .value("Price", cost.price)
            )
        }
    }
}

#Preview {
    ImmersiveView()
        .previewLayout(.sizeThatFits)
}
