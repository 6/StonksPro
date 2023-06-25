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

    var body: some View {
        VStack {
            Text("Hello, world!")
            if assetClass.isStocks {
                Text("Stock details here")
            } else if assetClass.isCrypto {
                Text("Crypto details here")
            } else {
                Text("Not yet implemented!")
            }
            Text(userSettings.polygonApiKey)
        }
        .navigationTitle(assetClass.title)
        .padding()
    }
}

struct StonksList_Previews: PreviewProvider {
    // A View that simply wraps the real view we're working on
    // Its only purpose is to hold state
    struct StonksPreviewContainer: View {
        @State var previewUserSettings: UserSettingsModel = UserSettingsModel()
        @State var previewAssetClass: AssetClassStruct = AssetClassStruct.getDefault

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
