//
//  Background.swift
//  Metallic Bird
//
//  Created by Alex Sigalos on 11/10/25.
//

import MetalKit

class Background: Treadmill {
    let size = Vector2(x: 288, y: 512)
    let scale: Float = 5.25

    init() {
        let transform = Transform2D(
            position: .zero,
            angle: 0,
            size: size,
            scale: scale
        )

        super.init(
            scrollSpeed: 300,
            baseName: "bg",
            textureName: "background",
            transform: transform
        )
    }
}
