//
//  StockDetailsView.swift
//  StonksPro
//
//  Created by Peter Graham on 6/26/23.
//

import SwiftUI
import Charts

struct StockDetailsView: View {
    var userSettings: UserSettingsModel
    var stock: AlphaVantageTopAsset
    @State var company: AlphaVantageCompanyOverview = AlphaVantageCompanyOverview.placeholder()
    @State var timeseries: [AlphaVantageTimeseriesValue] = []
    @State var isLoading: Bool = true
    
    func fetchDetails() async {
        isLoading = true
        do {
            company = try await AlphaVantageApiClient.fetchCompanyOverview(apiKey: userSettings.alphaVantageApiKey, symbol: stock.ticker, useMockData: userSettings.useMockStockData)
            timeseries = try await AlphaVantageApiClient.fetchTimeseries(apiKey: userSettings.alphaVantageApiKey, symbol: stock.ticker, useMockData: userSettings.useMockStockData)
            print("Successfully fetched stock details", Date())
            isLoading = false
        } catch {
            print("Unable to fetch stock details", error)
        }
    }
    
    struct ChartDatapoint: Identifiable {
        let id = UUID()
        let price: Float
        let date: Date
    }

    func getNormalizedChartData() -> [ChartDatapoint] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd' 'HH:mm:ss"
        var datapoints: [ChartDatapoint] = []
        for (_, datapoint) in timeseries.enumerated() {
            let date = dateFormatter.date(from: datapoint.timestamp) ?? Date()
            datapoints.append(ChartDatapoint(price: Float(datapoint.close) ?? 0, date: date))
        }
        return datapoints
    }

    func getYAxisDomain() -> ClosedRange<Float> {
        let allValues = timeseries.map { Float($0.close) ?? 0 }
        let minValue = allValues.min() ?? 0
        let maxValue = allValues.max() ?? 1
        return minValue...maxValue
    }

    var body: some View {
        List {
            if isLoading {
                ProgressView()
            } else {
                VStack {
                    Chart(getNormalizedChartData()) { datapoint in
                        LineMark(
                            x: .value("Date", datapoint.date),
                            y: .value("Price", datapoint.price)
                        ).interpolationMethod(.catmullRom)
                            .foregroundStyle(Color.green)
                            .lineStyle(StrokeStyle(lineWidth: 3))
                        AreaMark(
                            x: .value("Date", datapoint.date),
                            yStart: .value("Price", datapoint.price),
                            yEnd: .value("minValue", getYAxisDomain().lowerBound)
                        ).interpolationMethod(.catmullRom)
                            .foregroundStyle(
                                .linearGradient(
                                    colors: [Color.green.opacity(0.3), .clear],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                    }.chartYAxis {
                        AxisMarks(
                            format: Decimal.FormatStyle.Currency(code: "USD")
                        )
                    }.frame(minHeight: 260).padding(50)
                        .chartYScale(domain: getYAxisDomain())

                }.background(.thickMaterial).cornerRadius(15)
                
                VStack {
                    VStack(alignment: .leading) {
                        Text("Details").font(.title2).padding(.bottom, 20)
                        HStack {
                            Text("Market cap")
                            Spacer()
                            Text(formatDollar(value: Float(company.MarketCapitalization) ?? 0))
                        }
                        Divider()
                        HStack {
                            Text("Exchange")
                            Spacer()
                            Text(company.Exchange)
                        }
                        Divider()
                        HStack {
                            Text("Asset type")
                            Spacer()
                            Text(company.AssetType)
                        }
                    }.padding(.leading, 50).padding(.trailing, 50).padding(.top, 40).padding(.bottom, 40)
                }.background(.thickMaterial).cornerRadius(15)
                VStack {
                    VStack(alignment: .leading) {
                        Text("About \(company.Symbol) (\(company.Name))").font(.title2).padding(.bottom, 20)
                        Text(company.Description)
                    }.padding(.leading, 50).padding(.trailing, 50).padding(.top, 40).padding(.bottom, 40)
                }.background(.thickMaterial).cornerRadius(15)
            }
        }.navigationTitle(stock.ticker)
            .listStyle(.plain)
            .task(id: stock.ticker) {
                await fetchDetails()
            }
    }
}

#Preview {
    NavigationStack {
        let previewUserSettings: UserSettingsModel = UserSettingsModel()
        let mockStock = AlphaVantageTopAsset(
            ticker: "TSLA",
            price: "256.6",
            change_amount: "-8.01",
            change_percentage: "-3.0271%",
            volume: "175511290"
        )
        StockDetailsView(userSettings: previewUserSettings, stock: mockStock)
    }
}
