//
//  StonksListView.swift
//  StonksPro
//
//  Created by Peter Graham on 6/25/23.
//

import SwiftUI

// Coingecko response:
struct CryptoAssetResponse: Codable {
    let id: String // "bitcoin"
    let name: String // "Bitcoin"
    let image: String // "http://..."
    let current_price: Float // 30607.40261055006
    let price_change_percentage_1h_in_currency: Float // 0.08790266294799756
    let price_change_percentage_24h_in_currency: Float
    let price_change_percentage_7d_in_currency: Float
}

struct StonksListView: View {
    var userSettings: UserSettingsModel
    var assetClass: AssetClassStruct
    
    @State var cryptoAssets: [CryptoAssetResponse] = []

    
    func fetchCryptoAssets() async {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=USD&order=market_cap_desc&per_page=10&page=1&sparkline=true&price_change_percentage=1h%2C24h%2C7d&locale=en&precision=full") else {
            print("URL invalid")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedResponse = try JSONDecoder().decode([CryptoAssetResponse].self, from: data)
            cryptoAssets = decodedResponse;
            print("Successfully fetched crypto:", decodedResponse)
            
        } catch {
            print("Unable to fetch crypto quote: ",error)
        }
    }

    var body: some View {
        VStack {
            if assetClass.isStocks {
                Text("Stock details here")
            } else if assetClass.isCrypto {
                List(cryptoAssets, id: \.id) { item in
                    VStack(alignment: .leading) {
                        HStack {
                            AsyncImage(url: URL(string: item.image), scale: 10)
                            Text(item.name)
                                .font(.title)
                        }
                        Text("Price: $\(item.current_price)").font(.title3).padding(.top, 1)
                    }.padding(0)
                }
            } else {
                Text("Not yet implemented!")
            }
            Text(userSettings.polygonApiKey)
        }
        .navigationTitle(assetClass.title)
        .padding()
        .onAppear() {
            Task {
                if assetClass.isCrypto {
                    await fetchCryptoAssets()
                }
            }
        }
    }
}

struct StonksList_Previews: PreviewProvider {
    // A View that simply wraps the real view we're working on
    // Its only purpose is to hold state
    struct StonksPreviewContainer: View {
        @State var previewUserSettings: UserSettingsModel = UserSettingsModel()
        @State var previewAssetClass: AssetClassStruct = AssetClassStruct.crypto

        var body: some View {
            StonksListView(userSettings: previewUserSettings, assetClass: previewAssetClass)
        }
    }

    // Now, use that view wrapper here and we can mutate bindings
    static var previews: some View {
        NavigationStack {
            StonksPreviewContainer()
        }
    }
}
