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
            ContentView()
        }

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
        }
    }
}
