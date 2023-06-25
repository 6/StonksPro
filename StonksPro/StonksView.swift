//
//  ContentView.swift
//  StonksPro
//
//  Created by Peter Graham on 6/25/23.
//

import SwiftUI
import RealityKit
import RealityKitContent

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

// #Preview {
//    StonksView()
// }

struct Stonks_Previews: PreviewProvider {
    // A View that simply wraps the real view we're working on
    // Its only purpose is to hold state
    struct StonksPreviewContainer: View {
        @State var previewUserSettings: UserSettingsModel = UserSettingsModel()

        var body: some View {
            StonksView(userSettings: previewUserSettings)
        }
    }

    // Now, use that view wrapper here and we can mutate bindings
    static var previews: some View {
        StonksPreviewContainer()
    }
}
