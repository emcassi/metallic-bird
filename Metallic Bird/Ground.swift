//
//  Ground.swift
//  Metallic Bird
//
//  Created by Alex Sigalos on 11/10/25.
//

import MetalKit

class Ground: Treadmill {
    let size = Vector2(x: 336, y: 112)
    let scale: Float = 4
    static var groundY: Float = 0
    let baseName = "ground"
    let textureName = "ground"

    init() {
        let transform = Transform2D(
            position: .zero,
            angle: 0,
            size: size,
            scale: scale
        )

        super.init(
            scrollSpeed: 750,
            baseName: baseName,
            textureName: textureName,
            transform: transform
        )

        self.updateScreenSize()
    }

    func updateScreenSize() {
        Ground.groundY = Float(Renderer.windowSize.height) - size.y * scale

        let ground1 = child(name: "\(baseName)1")
        let ground2 = child(name: "\(baseName)2")
        ground1?.transform.position.y = Ground.groundY
        ground2?.transform.position.y = Ground.groundY
    }
}
