//
//  StonksListView.swift
//  StonksPro
//
//  Created by Peter Graham on 6/25/23.
//

import SwiftUI

struct StonksListView: View {
    var userSettings: UserSettingsModel
    var assetClass: AssetClassStruct

    @State var isLoading: Bool = true
    @State var cryptoAssets: [CoinGeckoAssetResponse] = []

    func fetchCryptoAssets() async {
        isLoading = true
        do {
            cryptoAssets = try await CoinGeckoApiClient.fetchTopCoins()
            print("Successfully fetched crypto", Date())
            isLoading = false
        } catch {
            print("Unable to fetch", error)
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
                                    Text(formatDollar(value: item.current_price)).font(.title3).padding(.top, 1)
                                }.padding(0)
                                Spacer()
                                VStack {
                                    Text("1h").font(.callout).bold()
                                    Text(formatPercent(percent: item.price_change_percentage_1h_in_currency)).foregroundColor(textColorForPercent(percent: item.price_change_percentage_1h_in_currency))
                                }
                                VStack {
                                    Text("24h").font(.callout).bold()
                                    Text(formatPercent(percent: item.price_change_percentage_24h_in_currency)).foregroundColor(textColorForPercent(percent: item.price_change_percentage_24h_in_currency))
                                }.padding(.leading)
                                VStack {
                                    Text("7d").font(.callout).bold()
                                    Text(formatPercent(percent: item.price_change_percentage_7d_in_currency)).foregroundColor(textColorForPercent(percent: item.price_change_percentage_7d_in_currency))
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
