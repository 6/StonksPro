//
//  StonksListView.swift
//  StonksPro
//
//  Created by Peter Graham on 6/25/23.
//

import SwiftUI

struct StonksListViewItemDollarChange: View {
    @State var header: String
    @State var value: Float?
    
    var body: some View {
        VStack {
            Text(header).font(.callout).bold()
            Text(formatDollar(value: value ?? 0)).foregroundColor(textColorForDollar(value: value ?? 0))
        }.padding(.trailing)
    }
}

struct StonksListViewItemPercentageChange: View {
    @State var header: String
    @State var percent: Float?
    
    var body: some View {
        VStack {
            Text(header).font(.callout).bold()
            Text(formatPercent(percent: percent ?? 0)).foregroundColor(textColorForPercent(percent: percent ?? 0))
        }.padding(.trailing)
    }
}

struct StonksListView: View {
    var userSettings: UserSettingsModel
    var assetClass: AssetClassStruct

    @State var isLoading: Bool = true
    @State var cryptoAssets: [CoinGeckoAssetResponse] = []
    @State var mostActiveStocks: [AlphaVantageTopAsset] = []
    @State var topGainersStocks: [AlphaVantageTopAsset] = []

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
            mostActiveStocks = response.most_actively_traded
            topGainersStocks = response.top_gainers
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
                    List(mostActiveStocks, id: \.ticker) { item in
                        NavigationLink(value: item.ticker) {
                            HStack {
                                VStack(alignment:.leading) {
                                    HStack {
                                        Text(item.ticker).font(.title)
                                    }
                                    Text(formatDollar(value: Float(item.price) ?? 0)).font(.title3).padding(.top, 1)
                                }.padding(0)
                                Spacer()
                                StonksListViewItemDollarChange(header: "Change $", value: Float(item.change_amount))
                                StonksListViewItemPercentageChange(header: "Change %", percent: Float(item.change_percentage.replacingOccurrences(of: "%", with: "")))
                            }
                        }.navigationDestination(for: String.self) { stockTicker in
                            if let stock = mostActiveStocks.first(where: {$0.ticker == stockTicker}) {
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
                                StonksListViewItemPercentageChange(header: "1h", percent: item.price_change_percentage_1h_in_currency)
                                StonksListViewItemPercentageChange(header: "24h", percent: item.price_change_percentage_24h_in_currency)
                                StonksListViewItemPercentageChange(header: "7d", percent: item.price_change_percentage_7d_in_currency)
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
