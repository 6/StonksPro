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
    let current_price: Float // 30607.40261055006
    let price_change_percentage_1h_in_currency: Float // 0.08790266294799756
    let price_change_percentage_24h_in_currency: Float
    let price_change_percentage_7d_in_currency: Float
}
