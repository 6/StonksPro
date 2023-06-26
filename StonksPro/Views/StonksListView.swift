//
//  StonksListView.swift
//  StonksPro
//
//  Created by Peter Graham on 6/25/23.
//

import SwiftUI

let maxDecimalsForPercent = 2

func formatPercent(percent: Float) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .percent
    formatter.minimumIntegerDigits = 1
    formatter.maximumIntegerDigits = 3
    formatter.minimumFractionDigits = maxDecimalsForPercent
    formatter.maximumFractionDigits = maxDecimalsForPercent
    formatter.locale = Locale(identifier: "en_US")
    var result = formatter.string(from: NSNumber(value: percent / 100)) ?? ""
    if percent.roundToDecimal(maxDecimalsForPercent) >= 0 {
        result = "+" + result
    }
    return result
}

func textColorForValue(value: Float) -> Color {
    if value.roundToDecimal(maxDecimalsForPercent) > 0 {
        return Color.green
    } else if value.roundToDecimal(2) < 0 {
        return Color(red: 1.0, green: 0.5, blue: 0.5)
    } else {
        return Color.gray
    }
}

struct StonksListView: View {
    var userSettings: UserSettingsModel
    var assetClass: AssetClassStruct

    @State var isLoading: Bool = true
    @State var cryptoAssets: [CoinGeckoAssetResponse] = []

    func fetchCryptoAssets() async {
        isLoading = true

        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=USD&order=market_cap_desc&per_page=50&page=1&sparkline=true&price_change_percentage=1h%2C24h%2C7d&locale=en&precision=full") else {
            print("URL invalid")
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedResponse = try JSONDecoder().decode([CoinGeckoAssetResponse].self, from: data)
            cryptoAssets = decodedResponse
            print("Successfully fetched crypto", Date())
            isLoading = false
        } catch {
            print("Unable to fetch crypto quote: ", error)
        }
    }

    var body: some View {
        NavigationStack {
            VStack {
                if isLoading {
                    ProgressView()
                } else if assetClass.isStocks {
                    Text("Not yet implemented!")
                } else if assetClass.isCrypto {
                    List(cryptoAssets, id: \.id) { item in
                        NavigationLink(value: item.id) {
                            HStack {
                                VStack(alignment: .leading) {
                                    HStack {
                                        AsyncImage(url: URL(string: item.image)) { image in
                                            image.resizable()
                                        } placeholder: {
                                            ProgressView()
                                        }.frame(width: 25, height: 25)

                                        Text(item.name)
                                            .font(.title)
                                    }
                                    Text("$\(item.current_price)").font(.title3).padding(.top, 1)
                                }.padding(0)
                                Spacer()
                                VStack {
                                    Text("1h").font(.callout).bold()
                                    Text(formatPercent(percent: item.price_change_percentage_1h_in_currency)).foregroundColor(textColorForValue(value: item.price_change_percentage_1h_in_currency))
                                }
                                VStack {
                                    Text("24h").font(.callout).bold()
                                    Text(formatPercent(percent: item.price_change_percentage_24h_in_currency)).foregroundColor(textColorForValue(value: item.price_change_percentage_24h_in_currency))
                                }.padding(.leading)
                                VStack {
                                    Text("7d").font(.callout).bold()
                                    Text(formatPercent(percent: item.price_change_percentage_7d_in_currency)).foregroundColor(textColorForValue(value: item.price_change_percentage_7d_in_currency))
                                }.padding(.leading).padding(.trailing)
                            }
                        }
                    }.navigationDestination(for: String.self) { cryptoId in
                        if let cryptoAsset = cryptoAssets.first(where: {$0.id == cryptoId}) {
                            CryptoDetailsView(cryptoAsset: cryptoAsset)
                        }
                    }

                } else {
                    Text("Not yet implemented!")
                }
            }
            .navigationTitle(assetClass.title)
            .padding()
            .task(id: assetClass.id) {
                if assetClass.isCrypto {
                    await fetchCryptoAssets()
                }
            }
        }
    }
}

#Preview {
    VStack {
        let previewUserSettings: UserSettingsModel = UserSettingsModel()
        let previewAssetClass: AssetClassStruct = AssetClassStruct.crypto
        StonksListView(userSettings: previewUserSettings, assetClass: previewAssetClass)
    }
}