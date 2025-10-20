//
//  MetalView.swift
//  Metallic Bird
//
//  Created by Alex Sigalos on 10/19/25.
//

import MetalKit
import SwiftUI

let size: CGSize = .init(width: 400, height: 875)

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
        func makeNSView(context _: Context) -> some NSView {
            metalView
        }

        func updateNSView(_: NSViewType, context _: Context) {
            updateMetalView()
        }

    #elseif os(iOS)
        func makeUIView(context _: Context) -> MTKView {
            metalView
        }

        func updateUIView(_: MTKView, context _: Context) {
            updateMetalView()
        }
    #endif

    func updateMetalView() {}
}

#Preview {
    MetalView()
}
