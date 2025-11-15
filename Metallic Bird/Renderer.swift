//
//  Renderer.swift
//  Metallic Bird
//
//  Created by Alex Sigalos on 10/19/25.
//

import MetalKit

class Renderer: NSObject {
    static var metalView: MTKView!

    static var windowSize = WindowSize()
    static var device: MTLDevice!

    private var commandQueue: MTLCommandQueue!
    private var library: MTLLibrary!

    private var mainVertexFunc: MTLFunction?
    private var mainFragmentFunc: MTLFunction?
    private var deathFlashVertexFunc: MTLFunction?
    private var deathFlashFragmentFunc: MTLFunction?

    static var proj: float4x4!

    private var renderState: MTLRenderPipelineState!
    private var deathFlashRenderState: MTLRenderPipelineState!

    private var lastFrameTime: CFTimeInterval = 0.0

    private var clearColor: MTLClearColor = .init(
        red: 0.2,
        green: 0.2,
        blue: 0.2,
        alpha: 1
    )

    private let game: Game

    init(metalView: MTKView, initialWindowSize: WindowSize) {
        Self.metalView = metalView
        guard
            let device = MTLCreateSystemDefaultDevice(),
            let commandQueue = device.makeCommandQueue()
        else {
            fatalError("GPU not available")
        }
        Self.device = device
        self.commandQueue = commandQueue
        metalView.device = device
        metalView.colorPixelFormat = .bgra8Unorm_srgb

        Self.windowSize = initialWindowSize

        game = Game(metalView: metalView)

        super.init()
        metalView.delegate = self

        library = makeLibrary()

        do {
            precondition(mainVertexFunc != nil, "main vertex shader not found")
            precondition(mainFragmentFunc != nil, "main fragment shader not found")

            renderState = try device.makeRenderPipelineState(
                descriptor: makePipelineDescriptor(
                    vertexFunc: mainVertexFunc!,
                    fragmentFunc: mainFragmentFunc!
                )
            )
        } catch {
            fatalError(
                "Failed to create pipeline state: \(error.localizedDescription)"
            )
        }

        do {
            precondition(deathFlashVertexFunc != nil, "death flash vertex shader not found")
            precondition(deathFlashFragmentFunc != nil, "death flash fragment shader not found")

            deathFlashRenderState = try device.makeRenderPipelineState(
                descriptor: makePipelineDescriptor(
                    vertexFunc: deathFlashVertexFunc!,
                    fragmentFunc: deathFlashFragmentFunc!
                )
            )
        } catch {
            fatalError(
                "Failed to create pipeline state: \(error.localizedDescription)"
            )
        }

        mtkView(metalView, drawableSizeWillChange: metalView.drawableSize)

        metalView.clearColor = clearColor
    }

    func makeLibrary() -> MTLLibrary? {
        let library = Self.device.makeDefaultLibrary()
        guard
            let library = library,
            let mainVertexFunc = library.makeFunction(name: "vertex_main"),
            let mainFragmentFunc = library.makeFunction(name: "fragment_main"),
            let deathFlashVertexFunc = library.makeFunction(name: "vertex_death_flash"),
            let deathFlashFragmentFunc = library.makeFunction(name: "fragment_death_flash")
        else {
            fatalError("Shaders not found")
        }
        self.mainVertexFunc = mainVertexFunc
        self.mainFragmentFunc = mainFragmentFunc
        self.deathFlashVertexFunc = deathFlashVertexFunc
        self.deathFlashFragmentFunc = deathFlashFragmentFunc
        return library
    }

    func makePipelineDescriptor(vertexFunc: MTLFunction, fragmentFunc: MTLFunction) -> MTLRenderPipelineDescriptor {
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexFunc
        pipelineDescriptor.fragmentFunction = fragmentFunc
        if let attachment = pipelineDescriptor.colorAttachments[0] {
            attachment.pixelFormat = Self.metalView.colorPixelFormat
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
        Self.windowSize.width = UInt32(size.width)
        Self.windowSize.height = UInt32(size.height)

        Self.proj = float4x4.ortho(
            left: 0,
            right: Float(Self.windowSize.width),
            bottom: Float(Self.windowSize.height),
            top: 0,
            near: 0,
            far: 1
        )

        if let ground = Game.world.child(name: "ground") as? Ground,
           let bird = Game.world.child(name: "bird") as? Bird,
           let scoreLabel = Game.world.child(name: "scoreLabel") as? ScoreLabel
        {
            ground.updateScreenSize()
            bird.updateScreenSize()
            scoreLabel.updateScreenSize()
        }
    }

    func update(_ deltaTime: Float) {
        game.update(deltaTime)
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
            let commandBuffer = commandQueue.makeCommandBuffer(),
            let rpDescriptor = view.currentRenderPassDescriptor,
            let renderEncoder = commandBuffer.makeRenderCommandEncoder(
                descriptor: rpDescriptor
            )
        else {
            return
        }
        renderEncoder.setRenderPipelineState(renderState)
        Game.world.draw(renderEncoder: renderEncoder)

        renderEncoder.setRenderPipelineState(deathFlashRenderState)
        Game.deathFlash.draw(renderEncoder: renderEncoder)

        renderEncoder.endEncoding()

        guard let drawable = view.currentDrawable else {
            return
        }

        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}
