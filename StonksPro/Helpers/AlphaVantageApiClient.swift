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
        if (useMockData) {
            let decodedResponse = try JSONDecoder().decode(AlphaVantageTopAssetsResponse.self, from: Data(mockAlphaVantageTopMoversResponse.utf8))
            return decodedResponse
        } else {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedResponse = try JSONDecoder().decode(AlphaVantageTopAssetsResponse.self, from: data)
            return decodedResponse
        }
    }
}

// AlphaVantage has strict rate limit so use mock response for testing/previews:
let mockAlphaVantageTopMoversResponse = """
{"metadata":"Top gainers, losers, and most actively traded US tickers","last_updated":"2023-06-23 16:15:58 US/Eastern","top_gainers":[{"ticker":"BYN+","price":"0.1763","change_amount":"0.1281","change_percentage":"265.7676%","volume":"670650"},{"ticker":"ADILW","price":"0.0199","change_amount":"0.0142","change_percentage":"249.1228%","volume":"4000"},{"ticker":"AMAOW","price":"0.0649","change_amount":"0.0437","change_percentage":"206.1321%","volume":"67912"},{"ticker":"HUBCZ","price":"0.4","change_amount":"0.2166","change_percentage":"118.1025%","volume":"28148"},{"ticker":"TMKRW","price":"0.03","change_amount":"0.016","change_percentage":"114.2857%","volume":"83498"},{"ticker":"BBLGW","price":"2.9","change_amount":"1.53","change_percentage":"111.6788%","volume":"6467"},{"ticker":"PIK","price":"1.17","change_amount":"0.59","change_percentage":"101.7241%","volume":"91291343"},{"ticker":"ACBAW","price":"0.0599","change_amount":"0.0299","change_percentage":"99.6667%","volume":"1702"},{"ticker":"SWSSW","price":"0.0199","change_amount":"0.0093","change_percentage":"87.7358%","volume":"5347"},{"ticker":"CFMS","price":"2.17","change_amount":"1.01","change_percentage":"87.069%","volume":"5520137"},{"ticker":"CREXW","price":"0.0102","change_amount":"0.0047","change_percentage":"85.4545%","volume":"4082"},{"ticker":"PLTNW","price":"0.11","change_amount":"0.0476","change_percentage":"76.2821%","volume":"32082"},{"ticker":"IRNT+","price":"0.0199","change_amount":"0.0085","change_percentage":"74.5614%","volume":"129840"},{"ticker":"ACAHW","price":"0.07","change_amount":"0.0298","change_percentage":"74.1294%","volume":"6028"},{"ticker":"DAVEW","price":"0.0434","change_amount":"0.0169","change_percentage":"63.7736%","volume":"783"},{"ticker":"XFINW","price":"0.065","change_amount":"0.025","change_percentage":"62.5%","volume":"197"},{"ticker":"HMACW","price":"0.05","change_amount":"0.019","change_percentage":"61.2903%","volume":"3526"},{"ticker":"BYNOW","price":"0.099","change_amount":"0.0372","change_percentage":"60.1942%","volume":"7789"},{"ticker":"FGMCW","price":"0.079","change_amount":"0.029","change_percentage":"58.0%","volume":"3668"},{"ticker":"AVHIW","price":"0.0299","change_amount":"0.0106","change_percentage":"54.9223%","volume":"6571"}],"top_losers":[{"ticker":"FMIVW","price":"0.0031","change_amount":"-0.0712","change_percentage":"-95.8277%","volume":"48542"},{"ticker":"IMACW","price":"0.0061","change_amount":"-0.0137","change_percentage":"-69.1919%","volume":"1816"},{"ticker":"VIIAW","price":"0.03","change_amount":"-0.0634","change_percentage":"-67.8801%","volume":"17449"},{"ticker":"WWACW","price":"0.03","change_amount":"-0.0598","change_percentage":"-66.5924%","volume":"489734"},{"ticker":"ARTEW","price":"0.0112","change_amount":"-0.0188","change_percentage":"-62.6667%","volume":"7198"},{"ticker":"LOV","price":"0.28","change_amount":"-0.4568","change_percentage":"-61.9978%","volume":"3566638"},{"ticker":"SMX","price":"0.179","change_amount":"-0.271","change_percentage":"-60.2222%","volume":"12773853"},{"ticker":"CNDB+","price":"0.0501","change_amount":"-0.0543","change_percentage":"-52.0115%","volume":"21600"},{"ticker":"SPIR","price":"0.35","change_amount":"-0.3627","change_percentage":"-50.891%","volume":"29680082"},{"ticker":"XBIOW","price":"5.7","change_amount":"-5.8","change_percentage":"-50.4348%","volume":"282"},{"ticker":"SNAXW","price":"0.015","change_amount":"-0.015","change_percentage":"-50.0%","volume":"53007"},{"ticker":"AIMAW","price":"0.0325","change_amount":"-0.0296","change_percentage":"-47.6651%","volume":"23409"},{"ticker":"EFHTW","price":"0.027","change_amount":"-0.024","change_percentage":"-47.0588%","volume":"10002"},{"ticker":"SBXC+","price":"0.1005","change_amount":"-0.0795","change_percentage":"-44.1667%","volume":"38467"},{"ticker":"GPACW","price":"0.0251","change_amount":"-0.0186","change_percentage":"-42.5629%","volume":"485"},{"ticker":"VSSYW","price":"0.0168","change_amount":"-0.0124","change_percentage":"-42.4658%","volume":"700"},{"ticker":"MTEKW","price":"0.0462","change_amount":"-0.0338","change_percentage":"-42.25%","volume":"2344"},{"ticker":"HMA+","price":"0.0128","change_amount":"-0.0089","change_percentage":"-41.0138%","volume":"457"},{"ticker":"STRCW","price":"0.039","change_amount":"-0.0262","change_percentage":"-40.184%","volume":"82105"},{"ticker":"SBEV+","price":"0.0679","change_amount":"-0.0443","change_percentage":"-39.4831%","volume":"8461"}],"most_actively_traded":[{"ticker":"TSLA","price":"256.6","change_amount":"-8.01","change_percentage":"-3.0271%","volume":"175511290"},{"ticker":"NU","price":"7.555","change_amount":"0.065","change_percentage":"0.8678%","volume":"160420179"},{"ticker":"MULN","price":"0.1696","change_amount":"-0.0086","change_percentage":"-4.826%","volume":"143075884"},{"ticker":"SQQQ","price":"20.02","change_amount":"0.6","change_percentage":"3.0896%","volume":"124273828"},{"ticker":"TQQQ","price":"38.95","change_amount":"-1.19","change_percentage":"-2.9646%","volume":"111855762"},{"ticker":"LUMN","price":"1.8","change_amount":"-0.05","change_percentage":"-2.7027%","volume":"110352621"},{"ticker":"FFIE","price":"0.2269","change_amount":"-0.0065","change_percentage":"-2.7849%","volume":"101023359"},{"ticker":"PIK","price":"1.17","change_amount":"0.59","change_percentage":"101.7241%","volume":"91291343"},{"ticker":"SPY","price":"433.31","change_amount":"-3.2","change_percentage":"-0.7331%","volume":"90957905"},{"ticker":"MARA","price":"12.71","change_amount":"0.88","change_percentage":"7.4387%","volume":"85403484"},{"ticker":"OPEN","price":"2.93","change_amount":"-0.24","change_percentage":"-7.571%","volume":"78360348"},{"ticker":"CNHI","price":"13.72","change_amount":"-0.66","change_percentage":"-4.5897%","volume":"75447075"},{"ticker":"CPNG","price":"16.6","change_amount":"-0.12","change_percentage":"-0.7177%","volume":"74752711"},{"ticker":"PLTR","price":"14.03","change_amount":"-0.02","change_percentage":"-0.1423%","volume":"74179804"},{"ticker":"AMD","price":"110.01","change_amount":"-0.69","change_percentage":"-0.6233%","volume":"73337040"},{"ticker":"AMZN","price":"129.33","change_amount":"-0.82","change_percentage":"-0.63%","volume":"70571866"},{"ticker":"WORX","price":"0.5222","change_amount":"0.1632","change_percentage":"45.4596%","volume":"68204152"},{"ticker":"SPCE","price":"4.32","change_amount":"-1.0","change_percentage":"-18.797%","volume":"66724515"},{"ticker":"SENS","price":"0.8192","change_amount":"-0.0749","change_percentage":"-8.3771%","volume":"65443400"},{"ticker":"NKLA","price":"1.29","change_amount":"-0.09","change_percentage":"-6.5217%","volume":"64706580"}]}
"""
