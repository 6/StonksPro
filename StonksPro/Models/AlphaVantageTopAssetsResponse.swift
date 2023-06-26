//
//  AlphaVantageTopAssetsResponse.swift
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
