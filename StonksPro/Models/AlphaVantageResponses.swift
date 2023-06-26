//
//  AlphaVantageResponses.swift
//  StonksPro
//
//  Created by Peter Graham on 6/26/23.
//

import Foundation

struct AlphaVantageTopAssetsResponse: Codable {
    let last_updated: String // "2023-06-23 16:15:58 US/Eastern"
    let top_gainers: [AlphaVantageTopAsset]
    let top_losers: [AlphaVantageTopAsset]
    let most_actively_traded: [AlphaVantageTopAsset]
}

struct AlphaVantageTopAsset: Codable {
    let ticker: String // "TSLA",
    let price: String // "256.6",
    let change_amount: String // "-8.01",
    let change_percentage: String // "-3.0271%",
    let volume: String // "175511290"
}

struct AlphaVantageCompanyOverview: Codable {
    let Symbol: String // "IBM"
    let AssetType: String // Common Stock
    let Name: String //International Business Machines
    let Description: String
    let Exchange: String // NYSE
    let MarketCapitalization: String // "117528257000"
    
    static func placeholder () -> AlphaVantageCompanyOverview {
        self.init(Symbol: "", AssetType: "", Name: "", Description: "", Exchange: "", MarketCapitalization: "")
    }
}

struct AlphaVantageTimeseriesValue: Codable {
    var timestamp: String // "2023-06-23 19:00:00"
    var open: String // "129.4300"
    var high: String
    var low: String
    var close: String // "129.3200"
    var volume: String
}

//struct AlphaVantageTimeSeriesIntradayResponse: Codable {
//    var TimeSeriesKey: String
//
//    private enum CodingKeys : String, CodingKey {
//        case TimeSeriesKey = "Time Series (60min)"
//    }
//}
