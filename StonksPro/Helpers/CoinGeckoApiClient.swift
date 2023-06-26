//
//  CoinGeckoApiClient.swift
//  StonksPro
//
//  Created by Peter Graham on 6/26/23.
//

import Foundation

struct CoinGeckoError: LocalizedError {
    let description: String

    init(_ description: String) {
        self.description = description
    }

    var errorDescription: String? {
        description
    }
}

class CoinGeckoApiClient {
    static func fetchTopCoins() async throws -> [CoinGeckoAssetResponse] {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=USD&order=market_cap_desc&per_page=50&page=1&sparkline=true&price_change_percentage=1h%2C24h%2C7d&locale=en&precision=full") else {
            throw CoinGeckoError("URL invalid")
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        let decodedResponse = try JSONDecoder().decode([CoinGeckoAssetResponse].self, from: data)
        return decodedResponse
    }
}
