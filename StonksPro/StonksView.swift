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

    @State var showImmersiveSpace = false

    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace
    
    var userSettings: UserSettingsModel

    var body: some View {
        NavigationSplitView {
            List {
                Button("Stocks") {}.padding()
                    .frame(width: 220)
                    .background(.regularMaterial, in: .rect(cornerRadius: 12))
                    .hoverEffect()
        
                Button("Crypto"){}.padding(.leading, 15).contrast(0.5).frame(width: 205)
                Button("Options"){}.padding(.leading, 15).padding(.top, 10).contrast(0.5).frame(width: 205)
            }
            .navigationSplitViewColumnWidth(min: 270, ideal: 280, max: 300)
        } detail: {
            VStack {
                Model3D(named: "Scene", bundle: realityKitContentBundle)
                    .padding(.bottom, 50)

                Text("Hello, world!")
                Text(userSettings.polygonApiKey)

                Toggle("Show ImmersiveSpace", isOn: $showImmersiveSpace)
                    .toggleStyle(.button)
                    .padding(.top, 50)
            }
            .navigationTitle("Content")
            .padding()
        }
        .onChange(of: showImmersiveSpace) { _, newValue in
            Task {
                if newValue {
                    await openImmersiveSpace(id: "ImmersiveSpace")
                } else {
                    await dismissImmersiveSpace()
                }
            }
        }
    }
}

//#Preview {
//    StonksView()
//}

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
