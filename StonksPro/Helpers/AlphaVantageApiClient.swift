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
    static func fetchTopMovers(apiKey: String, useMockData: Bool) async throws -> AlphaVantageTopAssetsResponse {
        guard let url = URL(string: "https://www.alphavantage.co/query?function=TOP_GAINERS_LOSERS&apikey=\(apiKey)") else {
            throw AlphaVantageError("URL invalid")
        }
        if useMockData {
            let decodedResponse = try JSONDecoder().decode(AlphaVantageTopAssetsResponse.self, from: Data(mockAlphaVantageTopMoversResponse.utf8))
            return decodedResponse
        } else {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedResponse = try JSONDecoder().decode(AlphaVantageTopAssetsResponse.self, from: data)
            return decodedResponse
        }
    }

    static func fetchCompanyOverview(apiKey: String, symbol: String, useMockData: Bool) async throws -> AlphaVantageCompanyOverview {
        guard let url = URL(string: "https://www.alphavantage.co/query?function=OVERVIEW&symbol=\(symbol)&apikey=\(apiKey)") else {
            throw AlphaVantageError("URL invalid")
        }
        if useMockData {
            let decodedResponse = try JSONDecoder().decode(AlphaVantageCompanyOverview.self, from: Data(mockCompanyOverviewResponse.utf8))
            return decodedResponse
        } else {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedResponse = try JSONDecoder().decode(AlphaVantageCompanyOverview.self, from: data)
            return decodedResponse
        }
    }

    static func fetchTimeseries(apiKey: String, symbol: String, useMockData: Bool) async throws -> [AlphaVantageTimeseriesValue] {
        // Fetch as CSV since JSON is highly complicated to decode using Swift (dynamic timestamp keys)
        guard let url = URL(string: "https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol=\(symbol)&apikey=\(apiKey)&interval=60min&outputsize=compact&datatype=csv") else {
            throw AlphaVantageError("URL invalid")
        }
        var timeseries: [AlphaVantageTimeseriesValue] = []
        var response: String
        if useMockData {
            response = mockTimeseriesResponse
        } else {
            let (data, _) = try await URLSession.shared.data(from: url)
            response = String(data: data, encoding: .utf8) ?? ""
            print("Response:", response)
        }
        var rows = response.components(separatedBy: "\n")
        // Remove header "timestamp,open,high,low,close,volume"
        rows.removeFirst()
        for row in rows {
            let columns = row.components(separatedBy: ",")
            if columns.count < 6 {
                continue
            }
            timeseries.append(AlphaVantageTimeseriesValue(
                timestamp: columns[0],
                open: columns[1], high: columns[2], low: columns[3], close: columns[4], volume: columns[5]
            ))
        }
        return timeseries
    }
}

// AlphaVantage has strict rate limit so use mock response for testing/previews:
let mockAlphaVantageTopMoversResponse = """
{"metadata":"Top gainers, losers, and most actively traded US tickers","last_updated":"2023-06-23 16:15:58 US/Eastern","top_gainers":[{"ticker":"BYN+","price":"0.1763","change_amount":"0.1281","change_percentage":"265.7676%","volume":"670650"},{"ticker":"ADILW","price":"0.0199","change_amount":"0.0142","change_percentage":"249.1228%","volume":"4000"},{"ticker":"AMAOW","price":"0.0649","change_amount":"0.0437","change_percentage":"206.1321%","volume":"67912"},{"ticker":"HUBCZ","price":"0.4","change_amount":"0.2166","change_percentage":"118.1025%","volume":"28148"},{"ticker":"TMKRW","price":"0.03","change_amount":"0.016","change_percentage":"114.2857%","volume":"83498"},{"ticker":"BBLGW","price":"2.9","change_amount":"1.53","change_percentage":"111.6788%","volume":"6467"},{"ticker":"PIK","price":"1.17","change_amount":"0.59","change_percentage":"101.7241%","volume":"91291343"},{"ticker":"ACBAW","price":"0.0599","change_amount":"0.0299","change_percentage":"99.6667%","volume":"1702"},{"ticker":"SWSSW","price":"0.0199","change_amount":"0.0093","change_percentage":"87.7358%","volume":"5347"},{"ticker":"CFMS","price":"2.17","change_amount":"1.01","change_percentage":"87.069%","volume":"5520137"},{"ticker":"CREXW","price":"0.0102","change_amount":"0.0047","change_percentage":"85.4545%","volume":"4082"},{"ticker":"PLTNW","price":"0.11","change_amount":"0.0476","change_percentage":"76.2821%","volume":"32082"},{"ticker":"IRNT+","price":"0.0199","change_amount":"0.0085","change_percentage":"74.5614%","volume":"129840"},{"ticker":"ACAHW","price":"0.07","change_amount":"0.0298","change_percentage":"74.1294%","volume":"6028"},{"ticker":"DAVEW","price":"0.0434","change_amount":"0.0169","change_percentage":"63.7736%","volume":"783"},{"ticker":"XFINW","price":"0.065","change_amount":"0.025","change_percentage":"62.5%","volume":"197"},{"ticker":"HMACW","price":"0.05","change_amount":"0.019","change_percentage":"61.2903%","volume":"3526"},{"ticker":"BYNOW","price":"0.099","change_amount":"0.0372","change_percentage":"60.1942%","volume":"7789"},{"ticker":"FGMCW","price":"0.079","change_amount":"0.029","change_percentage":"58.0%","volume":"3668"},{"ticker":"AVHIW","price":"0.0299","change_amount":"0.0106","change_percentage":"54.9223%","volume":"6571"}],"top_losers":[{"ticker":"FMIVW","price":"0.0031","change_amount":"-0.0712","change_percentage":"-95.8277%","volume":"48542"},{"ticker":"IMACW","price":"0.0061","change_amount":"-0.0137","change_percentage":"-69.1919%","volume":"1816"},{"ticker":"VIIAW","price":"0.03","change_amount":"-0.0634","change_percentage":"-67.8801%","volume":"17449"},{"ticker":"WWACW","price":"0.03","change_amount":"-0.0598","change_percentage":"-66.5924%","volume":"489734"},{"ticker":"ARTEW","price":"0.0112","change_amount":"-0.0188","change_percentage":"-62.6667%","volume":"7198"},{"ticker":"LOV","price":"0.28","change_amount":"-0.4568","change_percentage":"-61.9978%","volume":"3566638"},{"ticker":"SMX","price":"0.179","change_amount":"-0.271","change_percentage":"-60.2222%","volume":"12773853"},{"ticker":"CNDB+","price":"0.0501","change_amount":"-0.0543","change_percentage":"-52.0115%","volume":"21600"},{"ticker":"SPIR","price":"0.35","change_amount":"-0.3627","change_percentage":"-50.891%","volume":"29680082"},{"ticker":"XBIOW","price":"5.7","change_amount":"-5.8","change_percentage":"-50.4348%","volume":"282"},{"ticker":"SNAXW","price":"0.015","change_amount":"-0.015","change_percentage":"-50.0%","volume":"53007"},{"ticker":"AIMAW","price":"0.0325","change_amount":"-0.0296","change_percentage":"-47.6651%","volume":"23409"},{"ticker":"EFHTW","price":"0.027","change_amount":"-0.024","change_percentage":"-47.0588%","volume":"10002"},{"ticker":"SBXC+","price":"0.1005","change_amount":"-0.0795","change_percentage":"-44.1667%","volume":"38467"},{"ticker":"GPACW","price":"0.0251","change_amount":"-0.0186","change_percentage":"-42.5629%","volume":"485"},{"ticker":"VSSYW","price":"0.0168","change_amount":"-0.0124","change_percentage":"-42.4658%","volume":"700"},{"ticker":"MTEKW","price":"0.0462","change_amount":"-0.0338","change_percentage":"-42.25%","volume":"2344"},{"ticker":"HMA+","price":"0.0128","change_amount":"-0.0089","change_percentage":"-41.0138%","volume":"457"},{"ticker":"STRCW","price":"0.039","change_amount":"-0.0262","change_percentage":"-40.184%","volume":"82105"},{"ticker":"SBEV+","price":"0.0679","change_amount":"-0.0443","change_percentage":"-39.4831%","volume":"8461"}],"most_actively_traded":[{"ticker":"TSLA","price":"256.6","change_amount":"-8.01","change_percentage":"-3.0271%","volume":"175511290"},{"ticker":"NU","price":"7.555","change_amount":"0.065","change_percentage":"0.8678%","volume":"160420179"},{"ticker":"MULN","price":"0.1696","change_amount":"-0.0086","change_percentage":"-4.826%","volume":"143075884"},{"ticker":"SQQQ","price":"20.02","change_amount":"0.6","change_percentage":"3.0896%","volume":"124273828"},{"ticker":"TQQQ","price":"38.95","change_amount":"-1.19","change_percentage":"-2.9646%","volume":"111855762"},{"ticker":"LUMN","price":"1.8","change_amount":"-0.05","change_percentage":"-2.7027%","volume":"110352621"},{"ticker":"FFIE","price":"0.2269","change_amount":"-0.0065","change_percentage":"-2.7849%","volume":"101023359"},{"ticker":"PIK","price":"1.17","change_amount":"0.59","change_percentage":"101.7241%","volume":"91291343"},{"ticker":"SPY","price":"433.31","change_amount":"-3.2","change_percentage":"-0.7331%","volume":"90957905"},{"ticker":"MARA","price":"12.71","change_amount":"0.88","change_percentage":"7.4387%","volume":"85403484"},{"ticker":"OPEN","price":"2.93","change_amount":"-0.24","change_percentage":"-7.571%","volume":"78360348"},{"ticker":"CNHI","price":"13.72","change_amount":"-0.66","change_percentage":"-4.5897%","volume":"75447075"},{"ticker":"CPNG","price":"16.6","change_amount":"-0.12","change_percentage":"-0.7177%","volume":"74752711"},{"ticker":"PLTR","price":"14.03","change_amount":"-0.02","change_percentage":"-0.1423%","volume":"74179804"},{"ticker":"AMD","price":"110.01","change_amount":"-0.69","change_percentage":"-0.6233%","volume":"73337040"},{"ticker":"AMZN","price":"129.33","change_amount":"-0.82","change_percentage":"-0.63%","volume":"70571866"},{"ticker":"WORX","price":"0.5222","change_amount":"0.1632","change_percentage":"45.4596%","volume":"68204152"},{"ticker":"SPCE","price":"4.32","change_amount":"-1.0","change_percentage":"-18.797%","volume":"66724515"},{"ticker":"SENS","price":"0.8192","change_amount":"-0.0749","change_percentage":"-8.3771%","volume":"65443400"},{"ticker":"NKLA","price":"1.29","change_amount":"-0.09","change_percentage":"-6.5217%","volume":"64706580"}]}
"""

let mockCompanyOverviewResponse = """
{"Symbol":"IBM","AssetType":"Common Stock","Name":"International Business Machines","Description":"International Business Machines Corporation (IBM) is an American multinational technology company headquartered in Armonk, New York, with operations in over 170 countries. The company began in 1911, founded in Endicott, New York, as the Computing-Tabulating-Recording Company (CTR) and was renamed International Business Machines in 1924. IBM is incorporated in New York. IBM produces and sells computer hardware, middleware and software, and provides hosting and consulting services in areas ranging from mainframe computers to nanotechnology. IBM is also a major research organization, holding the record for most annual U.S. patents generated by a business (as of 2020) for 28 consecutive years. Inventions by IBM include the automated teller machine (ATM), the floppy disk, the hard disk drive, the magnetic stripe card, the relational database, the SQL programming language, the UPC barcode, and dynamic random-access memory (DRAM). The IBM mainframe, exemplified by the System/360, was the dominant computing platform during the 1960s and 1970s.","CIK":"51143","Exchange":"NYSE","Currency":"USD","Country":"USA","Sector":"TECHNOLOGY","Industry":"COMPUTER & OFFICE EQUIPMENT","Address":"1 NEW ORCHARD ROAD, ARMONK, NY, US","FiscalYearEnd":"December","LatestQuarter":"2023-03-31","MarketCapitalization":"117528257000","EBITDA":"12644000000","PERatio":"57.78","PEGRatio":"1.276","BookValue":"23.79","DividendPerShare":"6.6","DividendYield":"0.0513","EPS":"2.24","RevenuePerShareTTM":"66.97","ProfitMargin":"0.0303","OperatingMarginTTM":"0.132","ReturnOnAssetsTTM":"0.0376","ReturnOnEquityTTM":"0.101","RevenueTTM":"60585001000","GrossProfitTTM":"32688000000","DilutedEPSTTM":"2.24","QuarterlyEarningsGrowthYOY":"0.253","QuarterlyRevenueGrowthYOY":"0.004","AnalystTargetPrice":"140.79","TrailingPE":"57.78","ForwardPE":"15.55","PriceToSalesRatioTTM":"2.108","PriceToBookRatio":"6.75","EVToRevenue":"2.969","EVToEBITDA":"25.81","Beta":"0.853","52WeekHigh":"149.31","52WeekLow":"111.29","50DayMovingAverage":"128.44","200DayMovingAverage":"132.9","SharesOutstanding":"908045000","DividendDate":"2023-06-10","ExDividendDate":"2023-05-09"}
"""

let mockTimeseriesResponse = """
timestamp,open,high,low,close,volume
2023-06-23 19:00:00,129.4300,129.4500,129.2700,129.3200,2469719
2023-06-23 18:00:00,129.2760,129.6000,129.2700,129.2700,2469894
2023-06-23 17:00:00,131.1700,131.1700,129.2700,129.6000,166461
2023-06-23 16:00:00,129.4400,129.8500,129.0820,129.4500,13057514
2023-06-23 15:00:00,129.3250,129.8100,129.1800,129.4400,1032284
2023-06-23 14:00:00,129.7900,129.8000,129.2500,129.3300,388991
2023-06-23 13:00:00,129.7600,130.0000,129.6500,129.8000,222416
2023-06-23 12:00:00,129.8200,129.9700,129.5600,129.7500,281311
2023-06-23 11:00:00,129.9000,130.1000,129.4200,129.8100,433516
2023-06-23 10:00:00,130.3250,130.5200,129.8800,129.9000,440688
2023-06-23 09:00:00,130.8000,131.1180,129.8700,130.3600,319852
2023-06-23 08:00:00,131.0000,131.2800,130.5000,130.6200,1907
2023-06-23 07:00:00,131.0000,131.0700,130.9100,131.0000,274
2023-06-23 06:00:00,130.8900,131.0000,130.8400,130.9600,63
2023-06-23 05:00:00,130.8800,130.8800,130.7000,130.7000,53
2023-06-23 04:00:00,130.7500,131.2700,130.6900,130.9000,613
2023-06-22 19:00:00,131.1700,131.3500,131.1700,131.3400,538694
2023-06-22 18:00:00,131.3000,131.3800,131.1700,131.1700,538717
2023-06-22 17:00:00,133.6900,133.6900,129.7100,131.3400,276
2023-06-22 16:00:00,131.1700,131.3900,131.0000,131.3900,1772766
2023-06-22 15:00:00,131.2700,131.3780,131.0800,131.1700,1128883
2023-06-22 14:00:00,131.0200,131.3110,130.8900,131.2700,439035
2023-06-22 13:00:00,130.9100,131.0800,130.8050,131.0300,418994
2023-06-22 12:00:00,131.0000,131.0980,130.7700,130.9200,485537
2023-06-22 11:00:00,131.1500,131.3300,130.6800,131.0000,923424
2023-06-22 10:00:00,132.7400,132.7600,131.0250,131.1700,944530
2023-06-22 09:00:00,132.8700,132.9600,130.7600,132.7300,966598
2023-06-22 08:00:00,133.3300,133.6900,132.7000,133.0000,5482
2023-06-22 07:00:00,133.3300,133.4000,132.8500,132.8500,4315
2023-06-22 06:00:00,133.2700,133.3300,133.0400,133.0800,340
2023-06-22 05:00:00,133.3300,133.3300,133.3300,133.3300,21
2023-06-22 04:00:00,133.4700,133.4700,133.0700,133.3000,281
2023-06-21 19:00:00,133.6900,133.8900,133.6500,133.8600,754979
2023-06-21 18:00:00,133.9000,133.9000,133.6500,133.6500,755218
2023-06-21 17:00:00,135.9600,135.9600,133.6900,133.7200,38050
2023-06-21 16:00:00,133.7000,134.0000,133.6500,133.9000,2490781
2023-06-21 15:00:00,133.8700,134.0200,133.6000,133.7100,1031177
2023-06-21 14:00:00,133.7400,133.9700,133.5900,133.8700,401870
2023-06-21 13:00:00,133.9100,134.1400,133.7000,133.7350,575888
2023-06-21 12:00:00,134.2350,134.3000,133.7200,133.9200,395530
2023-06-21 11:00:00,133.7000,134.3700,133.5200,134.2350,707306
2023-06-21 10:00:00,134.1050,134.2700,133.2900,133.6900,745463
2023-06-21 09:00:00,135.9800,135.9800,133.5200,134.0900,623026
2023-06-21 08:00:00,136.0000,136.3800,135.7200,136.0000,1174
2023-06-21 07:00:00,136.1900,136.1900,136.0000,136.0100,212
2023-06-21 06:00:00,136.0800,136.2000,136.0000,136.0000,21
2023-06-21 05:00:00,135.9400,136.1200,135.8300,136.0800,96
2023-06-21 04:00:00,135.9500,136.1400,135.6800,136.1400,96
2023-06-20 19:00:00,135.9600,136.0000,135.8300,136.0000,590485
2023-06-20 18:00:00,135.8500,135.9600,135.8000,135.9600,589691
2023-06-20 17:00:00,135.9000,135.9900,135.8300,135.8800,263
2023-06-20 16:00:00,135.9800,136.5400,135.8300,135.9600,2074099
2023-06-20 15:00:00,136.4950,136.5600,135.8900,135.9800,1153744
2023-06-20 14:00:00,136.5600,136.6300,136.3500,136.5000,331062
2023-06-20 13:00:00,136.6900,136.8700,136.5300,136.5600,261065
2023-06-20 12:00:00,136.6200,136.7550,136.3400,136.6700,237980
2023-06-20 11:00:00,136.3500,136.7500,136.1200,136.6100,357356
2023-06-20 10:00:00,136.5000,137.2300,136.1900,136.3500,637055
2023-06-20 09:00:00,137.0600,137.4400,136.1100,136.4600,392880
2023-06-20 08:00:00,136.9400,141.8600,136.6110,137.3800,1950
2023-06-20 07:00:00,137.0800,137.1400,136.9400,137.0200,780
2023-06-20 06:00:00,136.8100,136.9400,136.7200,136.9000,490
2023-06-20 05:00:00,136.7300,136.7700,136.7300,136.7700,43
2023-06-20 04:00:00,137.4800,137.8700,136.7200,136.7200,1527
2023-06-16 19:00:00,137.4800,137.7800,137.4800,137.4800,2724801
2023-06-16 18:00:00,137.5700,137.7800,137.4800,137.7000,2724463
2023-06-16 17:00:00,139.2300,139.2300,137.4800,137.5800,4748
2023-06-16 16:00:00,137.5600,138.0000,137.2000,137.5100,8996060
2023-06-16 15:00:00,137.7400,137.9900,137.4700,137.5500,966229
2023-06-16 14:00:00,137.8300,137.9300,137.6900,137.7400,325190
2023-06-16 13:00:00,138.2200,138.2200,137.6020,137.8400,320444
2023-06-16 12:00:00,138.0700,138.5300,138.0500,138.2200,281419
2023-06-16 11:00:00,138.1600,138.2120,137.8200,138.0600,363875
2023-06-16 10:00:00,138.8800,139.0000,138.1400,138.1700,368040
2023-06-16 09:00:00,138.7000,139.4690,138.4000,138.8400,1292150
2023-06-16 08:00:00,138.7500,138.8600,138.1600,138.7330,2223
2023-06-16 07:00:00,138.6700,138.8200,138.2500,138.6000,1181
2023-06-16 06:00:00,138.7500,138.9700,138.7200,138.8200,432
2023-06-16 05:00:00,138.8500,138.8500,138.4900,138.4900,17
2023-06-16 04:00:00,138.4000,138.7700,138.4000,138.7700,29
2023-06-15 19:00:00,138.4000,138.8500,138.2100,138.4000,625871
2023-06-15 18:00:00,138.2200,138.4000,138.2200,138.3000,625704
2023-06-15 17:00:00,138.2800,138.6000,138.2000,138.2200,1714
2023-06-15 16:00:00,138.4300,138.4700,138.0000,138.3590,2000298
2023-06-15 15:00:00,138.7400,138.8000,138.2680,138.4300,952806
2023-06-15 14:00:00,138.0400,138.8000,137.9000,138.7400,439892
2023-06-15 13:00:00,138.2000,138.2500,137.8500,138.0400,320718
2023-06-15 12:00:00,138.3100,138.4500,138.1600,138.1900,319079
2023-06-15 11:00:00,137.9200,138.6200,137.9200,138.3200,341073
2023-06-15 10:00:00,138.0000,138.2400,137.5640,137.9100,411668
2023-06-15 09:00:00,136.9500,138.0300,136.7200,137.9900,272360
2023-06-15 08:00:00,137.1200,140.7000,136.6800,136.9500,2778
2023-06-15 07:00:00,136.9300,137.1900,136.9100,137.0200,1736
2023-06-15 06:00:00,136.9300,137.0800,136.8500,136.8600,102
2023-06-15 05:00:00,137.0800,137.1100,136.9000,136.9000,436
2023-06-15 04:00:00,137.2000,137.4400,137.0000,137.1400,248
2023-06-14 19:00:00,137.2000,137.5000,137.0100,137.2500,696849
2023-06-14 18:00:00,137.0610,137.5000,137.0100,137.3310,697032
2023-06-14 17:00:00,137.6000,137.6000,135.3660,137.5000,912
2023-06-14 16:00:00,137.2300,137.8800,136.8920,137.5000,2352097
"""
