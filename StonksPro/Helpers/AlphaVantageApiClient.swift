//
//  AlphaVantageApiClient.swift
//  StonksPro
//
//  Created by Peter Graham on 6/26/23.
//

import Foundation

struct AlphaVantageError: LocalizedError {
    let description: String

    init(_ description: String) {
        self.description = description
    }

    var errorDescription: String? {
        description
    }
}

class AlphaVantageApiClient {
    static func fetchTopMovers(apiKey: String) async throws -> AlphaVantageTopAssetsResponse {
        guard let url = URL(string: "https://www.alphavantage.co/query?function=TOP_GAINERS_LOSERS&apikey=\(apiKey)") else {
            throw AlphaVantageError("URL invalid")
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        let decodedResponse = try JSONDecoder().decode(AlphaVantageTopAssetsResponse.self, from: data)
        return decodedResponse
    }
}
