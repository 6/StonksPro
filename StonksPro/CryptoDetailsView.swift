//
//  StonkDetailsView.swift
//  StonksPro
//
//  Created by Peter Graham on 6/25/23.
//

import SwiftUI
import Charts
import Foundation

struct CryptoDetailsView: View {
    @State var cryptoAsset: CoinGeckoAssetResponse
    
    struct SparklineDatapoint: Identifiable {
        let id = UUID()
        let price: Float
        let date: Date
    }
    
    func getNormalizedSparklineData() -> [SparklineDatapoint] {
        let calendar = Calendar.current
        let startDate = calendar.date(byAdding: .weekOfYear, value: -1, to: Date()) ?? Date()
        var datapoints: [SparklineDatapoint] = []
        for (index, price) in cryptoAsset.sparkline_in_7d.price.enumerated() {
            let date =  calendar.date(byAdding: .hour, value: index, to: startDate) ?? Date()
            datapoints.append(SparklineDatapoint(price: price, date: date))
        }
        return datapoints
    }
    
    private func yAxisLabel(for yValue: Float) -> String {
        return yValue.formatted(.number.rounded(rule: .toNearestOrAwayFromZero))
    }

    var body: some View {
        VStack(alignment: .leading) {
            Chart(getNormalizedSparklineData()) { datapoint in
                AreaMark(
                    x: .value("Date", datapoint.date),
                    y: .value("Price", datapoint.price)
                )
            }.chartYAxis {
                AxisMarks(position: .leading) { value in
                    AxisGridLine()
                    AxisValueLabel(yAxisLabel(for: value))
                }
            }
            Text(String(cryptoAsset.sparkline_in_7d.price[0]))
            HStack {
                Text("TODO")
            }
            Spacer()
        }
        .navigationTitle(cryptoAsset.name)
        .padding(.leading, 30).padding(.trailing, 30)
    }
}

//#Preview {
//    StonkDetailsView()
//}
