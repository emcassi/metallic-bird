//
//  Metallic_BirdApp.swift
//  Metallic Bird
//
//  Created by Alex Sigalos on 10/19/25.
//

import SwiftUI

@main
struct Metallic_BirdApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .navigationTitle("Metallic Bird")
#if os(macOS)
                .frame(maxWidth: size.width, maxHeight: size.height)
#endif
        }
        .windowResizability(.contentSize)
    }
}
