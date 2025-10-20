//
//  Renderer.swift
//  Metallic Bird
//
//  Created by Alex Sigalos on 10/19/25.
//

import MetalKit

class Renderer: NSObject {
    static var device: MTLDevice!
    static var commandQueue: MTLCommandQueue!
    static var library: MTLLibrary!

    var renderState: MTLRenderPipelineState!
    var windowSize = WindowSize()

    private var quad: Quad

    private var seeded = false

    private var frameUniforms = FrameUniforms()
    private var instanceBuffer: MTLBuffer!
    private var instances: [SpriteInstance] = []
    private let maxInstances = 20

    init(metalView: MTKView) {
        guard
            let device = MTLCreateSystemDefaultDevice(),
            let commandQueue = device.makeCommandQueue()
        else {
            fatalError("GPU not available")
        }
        Self.device = device
        Self.commandQueue = commandQueue
        metalView.device = device

        guard let library = device.makeDefaultLibrary() else {
            fatalError("Unable to create default library")
        }
        Self.library = library
        guard
            let vertexFunc = library.makeFunction(name: "vertex_main"),
            let fragmentFunc = library.makeFunction(name: "fragment_main")
        else {
            fatalError("Shaders not found")
        }

        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexFunc
        pipelineDescriptor.fragmentFunction = fragmentFunc
        pipelineDescriptor
            .colorAttachments[0].pixelFormat = metalView.colorPixelFormat
        pipelineDescriptor.vertexDescriptor = .defaultDesc

        do {
            renderState = try device.makeRenderPipelineState(
                descriptor: pipelineDescriptor
            )
        } catch {
            fatalError(
                "Failed to create pipeline state: \(error.localizedDescription)"
            )
        }

        quad = Quad()

        super.init()
        metalView.delegate = self
        mtkView(metalView, drawableSizeWillChange: metalView.drawableSize)

        instances.reserveCapacity(maxInstances)

        metalView.clearColor = MTLClearColor(
            red: 0.2,
            green: 0.2,
            blue: 0.2,
            alpha: 1
        )
    }

    private func seedInstances(for size: CGSize) {
        instances.removeAll(keepingCapacity: true)

        let width = Float(size.width)
        let height = Float(size.height)

        func rand(_ min: Float, _ max: Float) -> Float { Float.random(in: min ... max) }

        for _ in 0 ..< maxInstances {
            let size = SIMD2<Float>(rand(48, 96), rand(48, 96))
            let half = size * 0.5
            // Center-anchored: keep fully on-screen
            let posX = rand(half.x, max(half.x, width - half.x))
            let posY = rand(half.y, max(half.y, height - half.y))
            let angle = rand(0, .pi * 2)

            instances.append(SpriteInstance(
                pos: SIMD2(posX, posY),
                size: size,
                cosTheta: cos(angle),
                sinTheta: sin(angle),
                z: 0,
            ))
        }
    }
}

extension Renderer: MTKViewDelegate {
    func mtkView(_: MTKView, drawableSizeWillChange size: CGSize) {
        windowSize.width = UInt32(size.width)
        windowSize.height = UInt32(size.height)

        frameUniforms.proj = float4x4.ortho(
            left: 0,
            right: Float(windowSize.width),
            bottom: Float(windowSize.height),
            top: 0,
            near: 0,
            far: 1
        )

        if !seeded, size.width > 0, size.height > 0 {
            seedInstances(for: size)
            seeded = true
        }
    }

    func draw(in view: MTKView) {
        guard seeded else { return }

        guard
            let commandBuffer = Self.commandQueue.makeCommandBuffer(),
            let rpDescriptor = view.currentRenderPassDescriptor,
            let renderEncoder = commandBuffer.makeRenderCommandEncoder(
                descriptor: rpDescriptor
            )
        else {
            return
        }
        renderEncoder.setRenderPipelineState(renderState)

        quad
            .draw(
                renderEncoder: renderEncoder,
                instances: instances,
                proj: frameUniforms
                    .proj
            )

        renderEncoder.endEncoding()

        guard let drawable = view.currentDrawable else {
            return
        }

        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}
