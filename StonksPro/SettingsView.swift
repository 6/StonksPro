//
//  SettingsView.swift
//  StonksPro
//
//  Created by Peter Graham on 6/25/23.
//

import SwiftUI

struct SettingsView: View {
    @Bindable var userSettings: UserSettingsModel

    var body: some View {
        NavigationStack {
            VStack(alignment:.leading) {
                Text("Enter your Polygon.io API Key:")
                    .bold()
                TextField("API Key", text: $userSettings.polygonApiKey).textFieldStyle(RoundedBorderTextFieldStyle())
                    .onChange(of: userSettings.polygonApiKey) { oldValue, newValue in
                        print("Updated auth token:", newValue)
                    }
                Spacer()
            }
            .navigationTitle("Settings")
            .padding(.leading, 30).padding(.trailing, 30)
            
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    // A View that simply wraps the real view we're working on
    // Its only purpose is to hold state
    struct SettingsContainer: View {
        @Bindable var previewUserSettings: UserSettingsModel = UserSettingsModel()

        var body: some View {
            SettingsView(userSettings: previewUserSettings)
        }
    }
    
    // Now, use that view wrapper here and we can mutate bindings
    static var previews: some View {
        SettingsContainer()
    }
}
