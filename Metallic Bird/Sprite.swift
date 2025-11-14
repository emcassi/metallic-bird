//
//  Sprite.swift
//  Metallic Bird
//
//  Created by Alex Sigalos on 10/19/25.
//

import MetalKit

class Sprite {
    let vertices: [UVVertex] = [
        UVVertex(position: SIMD2<Float>(0, 0), uv: SIMD2<Float>(0, 1)),
        UVVertex(position: SIMD2<Float>(1, 0), uv: SIMD2<Float>(1, 1)),
        UVVertex(position: SIMD2<Float>(0, 1), uv: SIMD2<Float>(0, 0)),
        UVVertex(position: SIMD2<Float>(1, 1), uv: SIMD2<Float>(1, 0)),
    ]

    let vertexBuffer: MTLBuffer!
    var frameUniforms = FrameUniforms()
    var texture: MTLTexture?
    var transform: Transform2D = .init()

    init() {
        guard
            let vertexBuffer = Renderer.device.makeBuffer(
                bytes: vertices,
                length: MemoryLayout<UVVertex>.stride * vertices.count,
                options: .storageModeShared
            )
        else {
            fatalError("Failed to create quad buffers")
        }
        self.vertexBuffer = vertexBuffer
    }

    func setTexture(name: String, type _: TextureIndices) {
        if let texture = TextureController.loadTexture(name: name) {
            self.texture = texture
        }
    }

    func draw(renderEncoder: MTLRenderCommandEncoder) {
        renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)

        let centerTranslation = float4x4(
            translateX: transform.size.x * transform.scale / 2, translateY: transform.size.y * transform.scale / 2
        )
        let translation = float4x4(
            translateX: transform.position.x,
            translateY: transform.position.y
        )
        let rotation = float4x4(rotate: transform.angle)
        let scale = float4x4(scaleX: transform.size.x * transform.scale, scaleY: transform.size.y * transform.scale)
        frameUniforms.transform = Renderer.proj * translation * centerTranslation * rotation * centerTranslation.inverse * scale

        renderEncoder
            .setVertexBytes(
                &frameUniforms,
                length: MemoryLayout<FrameUniforms>.stride,
                index: UniformsBuffer.index
            )

        if let texture = texture {
            renderEncoder.setFragmentTexture(texture, index: 0)
        }

        renderEncoder.setTriangleFillMode(.fill)
        renderEncoder
            .drawPrimitives(
                type: .triangleStrip,
                vertexStart: 0,
                vertexCount: vertices.count,
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
