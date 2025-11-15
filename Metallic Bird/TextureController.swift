//
//  TextureController.swift
//  Metallic Bird
//
//  Created by Alex Sigalos on 11/9/25.
//

import MetalKit

enum TextureController {
    static var textures: [String: MTLTexture] = [:]

    static func loadTexture(name: String) -> MTLTexture? {
        if let texture = textures[name] {
            return texture
        }

        let textureLoader = MTKTextureLoader(device: Renderer.device)
        let texture: MTLTexture?
        texture = try? textureLoader.newTexture(
            name: name,
            scaleFactor: 1.0,
            bundle: Bundle.main,
            options: nil
        )
        if texture != nil {
            textures[name] = texture
        }
        return texture
    }
}
