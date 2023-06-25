//
//  AssetClassModel.swift
//  StonksPro
//
//  Created by Peter Graham on 6/25/23.
//
import SwiftUI

// https://medium.com/@alessandromanilii/swiftui-navigationsplitview-b5ba2df07bb4
struct AssetClassStruct: Identifiable, Hashable {
    let title: String
    let id = UUID()
}

var stocksAssetClass = AssetClassStruct(title: "Stocks")
var cryptoAssetClass = AssetClassStruct(title: "Crypto")
var optionsAssetClass = AssetClassStruct(title: "Options")

extension AssetClassStruct {

    static var listAll: [AssetClassStruct] {
        [stocksAssetClass,
         cryptoAssetClass,
         optionsAssetClass
        ]
    }

    static var getDefault: AssetClassStruct {
        return stocksAssetClass
    }

    // TODO: better way?
    var isStocks: Bool {
        return self.id == stocksAssetClass.id
    }

    var isCrypto: Bool {
        return self.id == cryptoAssetClass.id
    }

    var isOptions: Bool {
        return self.id == optionsAssetClass.id
    }
}
