//
//  StonksListView.swift
//  StonksPro
//
//  Created by Peter Graham on 6/25/23.
//

import SwiftUI

struct StonksListViewItemPercentageChange: View {
    @State var timeframe: String
    @State var percent: Float
    
    var body: some View {
        VStack {
            Text(timeframe).font(.callout).bold()
            Text(formatPercent(percent: percent)).foregroundColor(textColorForPercent(percent: percent))
        }
    }
}

struct StonksListView: View {
    var userSettings: UserSettingsModel
    var assetClass: AssetClassStruct

    @State var isLoading: Bool = true
    @State var cryptoAssets: [CoinGeckoAssetResponse] = []
    @State var stocks: [AlphaVantageTopAsset] = []

    func fetchCryptoAssets() async {
        isLoading = true
        do {
            cryptoAssets = try await CoinGeckoApiClient.fetchTopCoins()
            print("Successfully fetched crypto", Date())
            isLoading = false
        } catch {
            print("Unable to fetch crypto", error)
        }
    }
    
    func fetchStocks() async {
        isLoading = true
        do {
            let response = try await AlphaVantageApiClient.fetchTopMovers(apiKey: userSettings.alphaVantageApiKey, useMockData: true)
            print("Successfully fetched stocks", Date())
            stocks = response.most_actively_traded
            isLoading = false
        } catch {
            print("Unable to fetch stocks", error)
        }
    }

    var body: some View {
        NavigationStack {
            VStack {
                if isLoading {
                    ProgressView()
                } else if assetClass.isStocks {
                    List(stocks, id: \.ticker) { item in
                        NavigationLink(value: item.ticker) {
                            Text("Stock")
                            Text(item.ticker)
                        }.navigationDestination(for: String.self) { stockTicker in
                            if let stock = stocks.first(where: {$0.ticker == stockTicker}) {
                                StockDetailsView(stock: stock)
                            }
                        }
                    }
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
                                StonksListViewItemPercentageChange(timeframe: "1h", percent: item.price_change_percentage_1h_in_currency)
                                StonksListViewItemPercentageChange(timeframe: "24h", percent: item.price_change_percentage_24h_in_currency).padding(.leading)
                                StonksListViewItemPercentageChange(timeframe: "7d", percent: item.price_change_percentage_7d_in_currency).padding(.leading).padding(.trailing)
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
                } else if assetClass.isStocks {
                    await fetchStocks()
                }
            }
        }
    }
}

#Preview {
    VStack {
        let previewUserSettings: UserSettingsModel = UserSettingsModel()
        let previewAssetClass: AssetClassStruct = AssetClassStruct.stocks
        StonksListView(userSettings: previewUserSettings, assetClass: previewAssetClass)
    }
}
