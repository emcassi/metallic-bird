//
//  DeathFlash.swift
//  Metallic Bird
//
//  Created by Alex Sigalos on 11/13/25.
//

import MetalKit

class DeathFlash {
    let vertices: [Vertex] = [
        Vertex(position: SIMD2<Float>(-1, -1)),
        Vertex(position: SIMD2<Float>(1, -1)),
        Vertex(position: SIMD2<Float>(-1, 1)),
        Vertex(position: SIMD2<Float>(1, 1)),
    ]

    let vertexBuffer: MTLBuffer!

    var active: Bool = false
    let length: Float = 0.5
    var timer: Float = 0
    var opacity: Float = 0

    init() {
        guard
            let vertexBuffer = Renderer.device.makeBuffer(
                bytes: vertices,
                length: MemoryLayout<Vertex>.stride * vertices.count,
                options: .storageModeShared
            )
        else {
            fatalError("Failed to create quad buffer")
        }
        self.vertexBuffer = vertexBuffer
    }

    func update(_ deltaTime: Float) {
        if !active { return }
        timer -= deltaTime

        let norm = 1 / length * timer
        opacity = norm * norm

        if timer <= 0 {
            active = false
        }
    }

    func draw(renderEncoder: MTLRenderCommandEncoder) {
        renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: VertexBuffer.index)
        renderEncoder.setFragmentBytes(&opacity, length: MemoryLayout<Float>.stride, index: UniformsBuffer.index)

        renderEncoder.setTriangleFillMode(.fill)
        renderEncoder
            .drawPrimitives(
                type: .triangleStrip,
                vertexStart: 0,
                vertexCount: vertices.count
            )
    }

    func setActive() {
        if active { return }
        timer = length
        active = true
    }
}
