//
//  StockDetailsView.swift
//  StonksPro
//
//  Created by Peter Graham on 6/26/23.
//

import SwiftUI
import Charts

struct StockDetailsView: View {
    @State var stock: AlphaVantageTopAsset

    var body: some View {
        List {
            Text("Stock details")
            Text(stock.ticker)
        }.navigationTitle(stock.ticker)
            .listStyle(.plain)
    }
}

#Preview {
    NavigationStack {
        let mockStock = AlphaVantageTopAsset(
            ticker: "TSLA",
            price: "256.6",
            change_amount: "-8.01",
            change_percentage: "-3.0271%",
            volume: "175511290"
        )
        StockDetailsView(stock: mockStock)
    }
}
