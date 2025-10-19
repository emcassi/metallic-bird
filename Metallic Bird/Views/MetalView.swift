//
//  MetalView.swift
//  Metallic Bird
//
//  Created by Alex Sigalos on 10/19/25.
//

import SwiftUI
import MetalKit

let size: CGSize = CGSize(width: 400, height: 875)

struct MetalView: View {
    @State private var metalView = MTKView()
    @State private var renderer: Renderer?

    var body: some View {
        MetalViewRepresentable(
            metalView: $metalView,
            renderer: renderer
        ).onAppear {
            renderer = Renderer(metalView: metalView)
        }
    }
}

#if os(macOS)
typealias ViewRepresentable = NSViewRepresentable
#elseif os(iOS)
typealias ViewRepresentable = UIViewRepresentable
#endif

struct MetalViewRepresentable: ViewRepresentable {
    @Binding var metalView: MTKView
    let renderer: Renderer?

#if os(macOS)
    func makeNSView(context: Context) -> some NSView {
        metalView
    }

    func updateNSView(_ nsView: NSViewType, context: Context) {
        updateMetalView()
    }
#elseif os(iOS)
    func makeUIView(context: Context) -> MTKView {
        metalView
    }
    func updateUIView(_ uiView: MTKView, context: Context) {
        updateMetalView()
    }
#endif

    func updateMetalView() {
    }
}

#Preview {
    MetalView()
}
