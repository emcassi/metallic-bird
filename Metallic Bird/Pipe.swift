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

    var hasScored: Bool = false

    init() {
        let gapMinY: Float = 400
        let gapMaxY = Float(1200)
        let gapStart = Float.random(in: gapMinY ... gapMaxY)
        let gapHeightMin: Float = 420
        let gapHeightMax: Float = 475
        let gapHeight = Float.random(in: gapHeightMin ... gapHeightMax)
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

        addChild(name: "topPipe", object: topPipe)
        addChild(name: "bottomPipe", object: bottomPipe)
    }

    func checkCollision() {
        guard let topPipe = child(name: "topPipe"),
              let bottomPipe = child(name: "bottomPipe"),
              let bird = Game.world.child(name: "bird")
        else {
            return
        }

        let topTransform = topPipe.applyParentTransform()
        let bottomTransform = bottomPipe.applyParentTransform()

        if aabb(transform: topTransform, other: bird.transform) || aabb(
            transform: bottomTransform,
            other: bird.transform
        ) {
            Game.gameState = .dying
        } else {}
    }

    func aabb(transform: Transform2D, other: Transform2D) -> Bool {
        let aWidth = transform.size.x * other.scale
        let aHeight = transform.size.y * other.scale

        let bWidth = other.size.x * other.scale
        let bHeight = other.size.y * other.scale

        return transform.position.x < other.position.x + bWidth &&
            transform.position.x + aWidth > other.position.x &&
            transform.position.y < other.position.y + bHeight &&
            transform.position.y + aHeight > other.position.y
    }

    override func update(_ deltaTime: Float, parent: GameObject? = nil) {
        if !hasScored, transform.position.x < Bird.startPos.x {
            hasScored = true
            ScoreController.increment()
        }
        checkCollision()
        super.update(deltaTime, parent: parent)
    }

    func shouldDelete() -> Bool {
        return transform.position.x + size.x * scale <= 0
    }
}
