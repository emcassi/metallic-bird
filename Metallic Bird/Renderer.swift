//
//  Renderer.swift
//  Metallic Bird
//
//  Created by Alex Sigalos on 10/19/25.
//

import MetalKit

class Renderer: NSObject {
    static var metalView: MTKView!
    static var safeAreaInsets: UIEdgeInsets!

    static var windowSize = WindowSize()
    static var device: MTLDevice!
    static var commandQueue: MTLCommandQueue!
    static var library: MTLLibrary!

    private var renderState: MTLRenderPipelineState!
    static var proj: float4x4!
    private var frameUniforms = FrameUniforms()
    private var lastFrameTime: CFTimeInterval = 0.0

    static var world: World = .init()
    static var soundboard: Soundboard = .init()

    static var gameState: GameState = .ready

    init(metalView: MTKView, initialWindowSize: WindowSize) {
        Renderer.metalView = metalView
        guard
            let device = MTLCreateSystemDefaultDevice(),
            let commandQueue = device.makeCommandQueue()
        else {
            fatalError("GPU not available")
        }
        Self.device = device
        Self.commandQueue = commandQueue
        metalView.device = device
        metalView.colorPixelFormat = .bgra8Unorm_srgb

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

        Renderer.windowSize = initialWindowSize

        super.init()
        metalView.delegate = self

        do {
            renderState = try device.makeRenderPipelineState(
                descriptor: makePipelineDescriptor(
                    vertexFunc: vertexFunc,
                    fragmentFunc: fragmentFunc
                )
            )
        } catch {
            fatalError(
                "Failed to create pipeline state: \(error.localizedDescription)"
            )
        }

        mtkView(metalView, drawableSizeWillChange: metalView.drawableSize)

        metalView.clearColor = MTLClearColor(
            red: 0.2,
            green: 0.2,
            blue: 0.2,
            alpha: 1
        )
    }

    func makePipelineDescriptor(vertexFunc: MTLFunction, fragmentFunc: MTLFunction) -> MTLRenderPipelineDescriptor {
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexFunc
        pipelineDescriptor.fragmentFunction = fragmentFunc
        if let attachment = pipelineDescriptor.colorAttachments[0] {
            attachment.pixelFormat = Renderer.metalView.colorPixelFormat
            attachment.isBlendingEnabled = true
            attachment.sourceRGBBlendFactor = .sourceAlpha
            attachment.destinationRGBBlendFactor = .oneMinusSourceAlpha

            attachment.sourceAlphaBlendFactor = .one
            attachment.destinationAlphaBlendFactor = .zero

            attachment.rgbBlendOperation = .add
            attachment.alphaBlendOperation = .add
        }
        pipelineDescriptor.vertexDescriptor = .defaultDesc

        return pipelineDescriptor
    }
}

extension Renderer: MTKViewDelegate {
    func mtkView(_: MTKView, drawableSizeWillChange size: CGSize) {
        Renderer.windowSize.width = UInt32(size.width)
        Renderer.windowSize.height = UInt32(size.height)
        Renderer.safeAreaInsets = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.safeAreaInsets ?? .zero

        Renderer.proj = float4x4.ortho(
            left: 0,
            right: Float(Renderer.windowSize.width),
            bottom: Float(Renderer.windowSize.height),
            top: 0,
            near: 0,
            far: 1
        )

        if let ground = Renderer.world.child(name: "ground") as? Ground,
           let bird = Renderer.world.child(name: "bird") as? Bird,
           let scoreLabel = Renderer.world.child(name: "scoreLabel") as? ScoreLabel
        {
            ground.updateScreenSize()
            bird.updateScreenSize()
            scoreLabel.updateScreenSize()
        }
    }

    func update(_ deltaTime: Float) {
        Renderer.world.update(deltaTime)
        Renderer.soundboard.queueUpdate()
    }

    func draw(in view: MTKView) {
        let currentTime = CACurrentMediaTime()

        if lastFrameTime == 0.0 {
            lastFrameTime = currentTime
        }
        let deltaTime = currentTime - lastFrameTime
        lastFrameTime = currentTime

        update(Float(deltaTime))

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

        Renderer.world.draw(renderEncoder: renderEncoder)

        renderEncoder.endEncoding()

        guard let drawable = view.currentDrawable else {
            return
        }

        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}
