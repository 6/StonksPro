//
//  CoinGeckoAssetResponse.swift
//  StonksPro
//
//  Created by Peter Graham on 6/25/23.
//

import Foundation

// Coingecko response:
struct CoinGeckoAssetResponse: Codable {
    let id: String // "bitcoin"
    let name: String // "Bitcoin"
    let image: String // "http://..."
    let market_cap: Float // 587735513384 (dollars)
    let total_volume: Float // 13107847368 (dollars - 24h)
    let current_price: Float // 30607.40261055006
    let high_24h: Float
    let low_24h: Float
    let price_change_percentage_1h_in_currency: Float // 0.08790266294799756
    let price_change_percentage_24h_in_currency: Float
    let price_change_percentage_7d_in_currency: Float
    let sparkline_in_7d: SparklinePrice
}

struct SparklinePrice: Codable {
    let price: [Float]
}
