//
//  StonksProApp.swift
//  StonksPro
//
//  Created by Peter Graham on 6/25/23.
//

import SwiftUI

@main
struct StonksProApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                StonksView()
                    .tabItem {
                        Label("Stonks", systemImage: "chart.line.uptrend.xyaxis")
                    }
                SettingsView()
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                    }
            }
        }

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
        }
    }
}
