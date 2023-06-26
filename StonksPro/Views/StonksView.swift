//
//  ContentView.swift
//  StonksPro
//
//  Created by Peter Graham on 6/25/23.
//

import SwiftUI
import RealityKit

struct StonksView: View {
    var userSettings: UserSettingsModel

    private let assetClasses = AssetClassStruct.listAll
    @State private var selectedAssetClass: AssetClassStruct? = AssetClassStruct.crypto

    var body: some View {
        NavigationSplitView {
            List(assetClasses, selection: $selectedAssetClass) { assetClass in
                NavigationLink(value: assetClass) {
                    Text(assetClass.title)
                }
            }
            .navigationTitle("Stonks Pro")
            .navigationSplitViewColumnWidth(min: 270, ideal: 280, max: 300)
        } detail: {
            if let selectedAssetClass {
                StonksListView(userSettings: userSettings, assetClass: selectedAssetClass)
            }
        }
    }
}

 #Preview {
     VStack {
         let previewUserSettings: UserSettingsModel = UserSettingsModel()
         StonksView(userSettings: previewUserSettings)
     }
 }
