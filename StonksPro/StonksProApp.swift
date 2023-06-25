//
//  StonksProApp.swift
//  StonksPro
//
//  Created by Peter Graham on 6/25/23.
//

import SwiftUI

@main
struct StonksProApp: App {
    @Bindable var userSettings: UserSettingsModel = UserSettingsModel()
    @State private var selectedImmersionStyle: ImmersionStyle = .mixed

    var body: some Scene {
        WindowGroup {
            TabView {
                StonksView(userSettings: userSettings)
                    .tabItem {
                        Label("Stonks", systemImage: "chart.line.uptrend.xyaxis")
                    }
                SettingsView(userSettings: userSettings)
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                    }
            }
        }
    }
}
