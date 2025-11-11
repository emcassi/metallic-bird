//
//  ContentView.swift
//  Metallic Bird
//
//  Created by Alex Sigalos on 10/19/25.
//

import SwiftUI

struct ContentView: View {
    @State private var tapped = false

    var tap: some Gesture {
        TapGesture(count: 1)
            .onEnded { _ in
                self.tapped = !self.tapped
            }
    }

    var body: some View {
        MetalView()
            .onTapGesture(count: 1) {
                InputController.taps += 1
            }
            .ignoresSafeArea()
    }
}

#Preview {
    ContentView()
}
