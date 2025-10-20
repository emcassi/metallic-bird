//
//  Quad.swift
//  Metallic Bird
//
//  Created by Alex Sigalos on 10/19/25.
//

import MetalKit

class Quad {
    let vertices = [
        SIMD2<Float>(-0.5, -0.5),
        SIMD2<Float>(0.5, -0.5),
        SIMD2<Float>(-0.5, 0.5),
        SIMD2<Float>(0.5, 0.5),
    ]

    let vertexBuffer: MTLBuffer!

    var frameUniforms = FrameUniforms()

    init() {
        guard
            let vertexBuffer = Renderer.device.makeBuffer(
                bytes: vertices,
                length: MemoryLayout<SIMD2<Float>>.stride * vertices.count,
                options: .storageModeShared
            )
        else {
            fatalError("Failed to create quad buffers")
        }
        self.vertexBuffer = vertexBuffer
    }

    func draw(
        renderEncoder: MTLRenderCommandEncoder,
        instances: [SpriteInstance],
        proj: float4x4
    ) {
        renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        var uniforms = FrameUniforms(proj: proj)
        renderEncoder
            .setVertexBytes(
                &uniforms,
                length: MemoryLayout<FrameUniforms>.stride,
                index: UniformsBuffer.index
            )

        var instances = instances
        guard let instanceBuffer = Renderer.device.makeBuffer(
            bytes: &instances,
            length: MemoryLayout<SpriteInstance>.stride * instances.count
        ) else {
            fatalError("Failed to create instance buffer")
        }
        renderEncoder.setVertexBuffer(instanceBuffer, offset: 0, index: 1)

        renderEncoder.setTriangleFillMode(.fill)
        renderEncoder
            .drawPrimitives(
                type: .triangleStrip,
                vertexStart: 0,
                vertexCount: 4,
                instanceCount: instances.count
            )
    }
}

extension Buffers {
    var index: Int {
        Int(rawValue)
    }
}

extension Attributes {
    var index: Int {
        Int(rawValue)
    }
}

extension MTLVertexDescriptor {
    static let defaultDesc = {
        let desc = MTLVertexDescriptor()
        desc.attributes[0].format = .float2
        desc.attributes[0].offset = 0
        desc.attributes[0].bufferIndex = 0
        desc.layouts[0].stride = MemoryLayout<SIMD2<Float>>.stride
        return desc
    }()
}
