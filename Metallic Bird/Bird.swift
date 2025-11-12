//
//  Bird.swift
//  Metallic Bird
//
//  Created by Alex Sigalos on 11/10/25.
//

import MetalKit

class Bird: GameObject {
    let textureName = "bird"

    var startPos: Vector2 = .zero

    let gravity: Float = 30
    let jumpForce: Float = -1100

    let tiltAngle = Float.pi / 4

    var minY: Float!
    var maxY: Float!

    var isDead: Bool = false

    init() {
        super.init(textureName: textureName)

        let transform = Transform2D(
            position: startPos,
            angle: 0,
            size: Vector2(x: 34, y: 24),
            scale: 4
        )
        self.transform = transform
        self.updateScreenSize()
        self.transform.position = startPos
    }

    override func update(_ deltaTime: Float, parent _: GameObject? = nil) {
        if InputController.taps > 0 {
            onTap()
        }
        if Renderer.gameState == .ready {
            transform.position = startPos
            return
        } else if Renderer.gameState == .gameOver, !isDead {
            die()
        }

        if velocity.y > 50 {
            transform.angle = Float.lerp(transform.angle, -tiltAngle, 0.3)
        } else if velocity.y < -50 {
            transform.angle = Float.lerp(transform.angle, tiltAngle, 0.3)
        } else {
            transform.angle = Float.lerp(transform.angle, 0, 0.3)
        }

        velocity.y += gravity

        super.update(deltaTime, parent: parent)

        if transform.position.y <= minY {
            transform.position.y = minY
            die()
            return
        }

        if transform.position.y >= maxY {
            transform.position.y = maxY
            transform.angle = -tiltAngle
            die()
            return
        }
    }

    func updateScreenSize() {
        let size = Vector2(x: Float(Renderer.windowSize.width), y: Float(Renderer.windowSize.height))

        startPos = Vector2(x: size.x / 4, y: size.y / 2)
        minY = Float(Renderer.safeAreaInsets.top) + transform.size.y * transform.scale
        maxY = Ground.groundY - transform.size.y * transform.scale * 3 / 4
    }

    func onTap() {
        switch Renderer.gameState {
        case .ready:
            Renderer.gameState = .playing
            velocity.y = jumpForce
        case .playing:
            velocity.y = jumpForce
        case .gameOver:
            Renderer.world.reset()
        }
        InputController.taps -= 1
    }

    func die() {
        Renderer.gameState = .gameOver
        velocity = .zero
        isDead = true
    }
}
