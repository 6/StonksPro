//
//  StonkDetailsView.swift
//  StonksPro
//
//  Created by Peter Graham on 6/25/23.
//

import SwiftUI

struct CryptoDetailsView: View {
    @State var cryptoAsset: CoinGeckoAssetResponse

    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        Text(cryptoAsset.name)
    }
}

//#Preview {
//    StonkDetailsView()
//}
