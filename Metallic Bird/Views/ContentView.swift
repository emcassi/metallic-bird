//
//  ContentView.swift
//  Metallic Bird
//
//  Created by Alex Sigalos on 10/19/25.
//

import SwiftUI

struct ContentView: View {
    @State private var canTap = true

    var tap: some Gesture {
        DragGesture(minimumDistance: 0.0, coordinateSpace: .global)
            .onChanged { _ in
                if canTap {
                    InputController.taps += 1
                }
                canTap = false
            }

            .onEnded { _ in
                canTap = true
            }
    }

    var body: some View {
        MetalView()
            .ignoresSafeArea()
            .gesture(tap)
    }
}

#Preview {
    ContentView()
}
