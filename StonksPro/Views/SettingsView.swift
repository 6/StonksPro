//
//  SettingsView.swift
//  StonksPro
//
//  Created by Peter Graham on 6/25/23.
//

import SwiftUI

struct SettingsView: View {
    @State var isApiKeyVisible: Bool = false
    @Bindable var userSettings: UserSettingsModel

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Text("Enter your AlphaVantage API Key:")
                    .bold()
                HStack {
                    ZStack {
                        TextField("API Key", text: $userSettings.alphaVantageApiKey).textFieldStyle(RoundedBorderTextFieldStyle())
                            .onChange(of: userSettings.alphaVantageApiKey) { _, newValue in
                                print("Updated key:", newValue)
                            }
                            .opacity(isApiKeyVisible ? 1 : 0)

                        SecureField("API Key",
                                    text: $userSettings.alphaVantageApiKey)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .opacity(isApiKeyVisible ? 0 : 1)
                    }
                    Button {
                                isApiKeyVisible.toggle()
                            } label: {
                                Image(systemName: isApiKeyVisible ? "eye.slash.fill" : "eye.fill")
                            }
                            .padding(.trailing, 8)
                }
                Spacer()
            }
            .navigationTitle("Settings")
            .padding(.leading, 30).padding(.trailing, 30)

        }
    }
}

#Preview {
    VStack {
        let previewUserSettings: UserSettingsModel = UserSettingsModel()
        SettingsView(userSettings: previewUserSettings)
    }
}
