//
//  CryptoDetailsView.swift
//  StonksPro
//
//  Created by Peter Graham on 6/25/23.
//

import SwiftUI
import Charts

struct CryptoDetailsView: View {
    @State var cryptoAsset: CoinGeckoAssetResponse

    struct SparklineDatapoint: Identifiable {
        let id = UUID()
        let price: Float
        let date: Date
    }

    func getNormalizedSparklineData() -> [SparklineDatapoint] {
        let calendar = Calendar.current
        let startDate = calendar.date(byAdding: .weekOfYear, value: -1, to: Date()) ?? Date()
        var datapoints: [SparklineDatapoint] = []
        for (index, price) in cryptoAsset.sparkline_in_7d.price.enumerated() {
            let date =  calendar.date(byAdding: .hour, value: index, to: startDate) ?? Date()
            datapoints.append(SparklineDatapoint(price: price, date: date))
        }
        return datapoints
    }

    func getYAxisDomain() -> ClosedRange<Float> {
        let minValue = cryptoAsset.sparkline_in_7d.price.min() ?? 0
        let maxValue = cryptoAsset.sparkline_in_7d.price.max() ?? 1
        return minValue...maxValue
    }

    var body: some View {
        List {
                VStack {
                    Chart(getNormalizedSparklineData()) { datapoint in
                        LineMark(
                            x: .value("Date", datapoint.date),
                            y: .value("Price", datapoint.price)
                        ).interpolationMethod(.catmullRom)
                            .foregroundStyle(Color.green)
                            .lineStyle(StrokeStyle(lineWidth: 3))
                        AreaMark(
                            x: .value("Date", datapoint.date),
                            yStart: .value("Price", datapoint.price),
                            yEnd: .value("minValue", getYAxisDomain().lowerBound)
                        ).interpolationMethod(.catmullRom)
                            .foregroundStyle(
                                .linearGradient(
                                    colors: [Color.green.opacity(0.3), .clear],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                    }.chartYAxis {
                        AxisMarks(
                            format: Decimal.FormatStyle.Currency(code: "USD")
                        )
                    }.frame(minHeight: 260).padding(50)
                        .chartYScale(domain: getYAxisDomain())

                }.background(.thickMaterial).cornerRadius(15)

            VStack {
                VStack(alignment: .leading) {
                    Text("Stats").font(.title2).padding(.bottom, 20)
                    HStack {
                        Text("Market cap")
                        Spacer()
                        Text(formatDollar(value: cryptoAsset.market_cap))
                    }
                    Divider()
                    HStack {
                        Text("24h Volume")
                        Spacer()
                        Text(formatDollar(value: cryptoAsset.total_volume))
                    }
                    Divider()
                    HStack {
                        Text("24h High")
                        Spacer()
                        Text(formatDollar(value: cryptoAsset.high_24h))
                    }
                    Divider()
                    HStack {
                        Text("24h Low")
                        Spacer()
                        Text(formatDollar(value: cryptoAsset.low_24h))
                    }
                }.padding(.leading, 50).padding(.trailing, 50).padding(.top, 40).padding(.bottom, 40)
            }.background(.thickMaterial).cornerRadius(15)

        }.navigationTitle(cryptoAsset.name)
            .listStyle(.plain)
    }
}

#Preview {
    NavigationStack {
        let mockCryptoAsset = CoinGeckoAssetResponse(
            id: "bitcoin",
            name: "Bitcoin",
            image: "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579",
            market_cap: 587735513384,
            total_volume: 13107847368,
            current_price: 30078.333455664757,
            high_24h: 30984,
            low_24h: 30279,
            price_change_percentage_1h_in_currency: -1.5037256644438743,
            price_change_percentage_24h_in_currency: -1.7190923446221293,
            price_change_percentage_7d_in_currency: 14.038481429750115,
            sparkline_in_7d: SparklinePrice(price: [26333.092529664373, 26375.59977874099, 26417.403577082012, 26438.101694032128, 26406.661631446274, 26393.59438344168, 26458.67417839566, 26419.76146495436, 26427.143113784277, 26401.464975578616, 26384.39199115479, 26399.3901418371, 26419.43037590655, 26520.6523506132, 26524.43698875481, 26415.22794739946, 26436.939367691153, 26487.164032947865, 26651.618782292957, 26822.67788670833, 26646.152055211576, 26759.122721856078, 26724.605158053364, 26758.634634286285, 26779.387461522838, 26945.93092584924, 26878.702381281302, 26910.466766788075, 26892.39378888698, 26941.07262952162, 26865.622668526656, 26792.696527903194, 26824.325583320697, 26746.29995957336, 26789.279360767134, 26774.26434038824, 26813.0794474436, 26864.48565836684, 26876.886381335516, 26758.89354668448, 27029.600397320184, 27285.730243287257, 27626.921809082825, 28038.839403345144, 27944.576865610663, 28093.56933866757, 28124.68073278554, 28226.711040663067, 28334.456254875357, 28383.149880196408, 28757.197162972625, 28767.36067661127, 28712.904643061873, 28780.821084987176, 28933.488301225374, 28794.57066986673, 28866.41231468552, 28818.076714745854, 28927.37899368003, 28883.355153366632, 28995.681420960504, 28922.69884176608, 29358.973412204905, 29403.332519407486, 29860.17507830133, 30380.15012168668, 30032.299637518394, 30163.571080455335, 30128.232480870298, 29966.658846334474, 29918.624872589247, 30019.99972603311, 30101.764819488686, 30140.980492892875, 30155.57420626367, 30354.24010005124, 30250.703926736416, 30261.071301033357, 30279.510925726827, 30120.2890226116, 30109.230535219514, 30098.25332070478, 30112.188830620395, 30219.633853696996, 29923.347790968408, 30108.40529950787, 30262.74304967667, 29923.31406667842, 29779.36326737228, 29952.78202027777, 30150.275362618464, 30067.813515549078, 30167.25428957438, 30160.68471185259, 30032.03072369572, 29990.438681814307, 29935.632106749556, 30024.17749236586, 30008.83951926442, 29970.406455191685, 30017.269906476122, 30000.35130419774, 30045.89112521761, 30006.9917276219, 29960.13524020479, 30026.842797016867, 30004.51721478935, 30103.288035249047, 30095.934842009796, 30119.997562159417, 30012.92340770855, 30268.526964196288, 30982.752567804153, 30977.251274608752, 31185.219831413775, 30930.14672404951, 30813.13994256805, 30909.18288158918, 30716.10018321133, 30651.267124205628, 30629.24435333575, 30497.814422760795, 30580.318716052872, 30779.256199291853, 30747.41026602438, 30724.745557757993, 30720.38116574939, 30724.50097466763, 30635.39927111461, 30593.713077589906, 30628.594418598434, 30744.29522703475, 30702.20649474433, 30700.698752018914, 30644.09610418547, 30688.68297717192, 30403.97736807775, 30489.827643480003, 30619.454947685168, 30664.56321186234, 30647.404676137427, 30564.886468465585, 30529.59423885306, 30523.24113160855, 30537.816664634793, 30529.954155372398, 30626.81854979441, 30658.41969993051, 30787.55658123859, 30943.91000335516, 30868.72227525015, 30847.342963438237, 30723.987969083413, 30749.26959122274, 30714.119149097933, 30613.856331252602, 30652.59455845883, 30661.393915968532, 30659.651055706494, 30582.647334317116, 30560.926979257594, 30586.298214996572, 30577.775617385185, 30422.348885621876, 30402.604991350127, 30494.43490593407, 30452.382329695585, 30517.730672385238
        ]))
        CryptoDetailsView(cryptoAsset: mockCryptoAsset)
    }
}
