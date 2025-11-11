//
//  Pipe.swift
//  Metallic Bird
//
//  Created by Alex Sigalos on 11/10/25.
//

import Metal

class Pipe: GameObject {
    let size = Vector2(x: 52, y: 600)
    let scale: Float = 4
    let textureName = "pipe"

    let screenSize = Renderer.windowSize

    let scrollSpeed: Float = -800

    init() {
        let gapMinY: Float = 400
        let gapMaxY = Float(screenSize.height - 1400)
        let gapStart = Float.random(in: gapMinY ... gapMaxY)
        let gapHeight = Float.random(in: 550 ... 700)
        let topPipeY = gapStart - size.y * scale
        let bottomPipeY = gapStart + gapHeight

        let topPipe = GameObject(textureName: textureName)
        topPipe.transform.position.y = topPipeY
        topPipe.transform.angle = Float.pi
        topPipe.transform.size = size

        let bottomPipe = GameObject(textureName: textureName)
        bottomPipe.transform.position.y = bottomPipeY
        bottomPipe.transform.size = size
        super.init()

        transform = Transform2D(
            position: Vector2(x: Float(screenSize.width), y: 0),
            angle: 0,
            size: .zero,
            scale: scale
        )

        velocity.x = scrollSpeed

        addChild(name: "top", object: topPipe)
        addChild(name: "bottom", object: bottomPipe)
    }

    func update(_ deltaTime: Float) {
        super.update(deltaTime)
    }

    func shouldDelete() -> Bool {
        return transform.position.x + size.x * scale <= 0
    }
}
