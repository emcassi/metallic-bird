//
//  Treadmill.swift
//  Metallic Bird
//
//  Created by Alex Sigalos on 11/11/25.
//

class Treadmill: GameObject {
    let first: GameObject
    let second: GameObject

    let scrollSpeed: Float

    let width: Float

    init(scrollSpeed: Float, baseName: String, textureName: String, transform: Transform2D) {
        self.scrollSpeed = scrollSpeed
        width = transform.size.x * transform.scale

        first = GameObject(textureName: textureName)
        first.transform = transform

        second = GameObject(textureName: textureName)
        second.transform = transform
        second.transform.position.x = width

        super.init()

        addChild(name: "\(baseName)1", object: first)
        addChild(name: "\(baseName)2", object: second)
    }

    override func update(_ deltaTime: Float, parent _: GameObject? = nil) {
        super.update(deltaTime, parent: parent)

        if Renderer.gameState != .playing {
            return
        }

        first.transform.position.x -= scrollSpeed * deltaTime
        second.transform.position.x -= scrollSpeed * deltaTime

        if first.transform.position.x + width <= 0 {
            first.transform.position.x += 2 * width
        }

        if second.transform.position.x + width <= 0 {
            second.transform.position.x += 2 * width
        }
    }
}
