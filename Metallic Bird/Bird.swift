//
//  Bird.swift
//  Metallic Bird
//
//  Created by Alex Sigalos on 11/10/25.
//

import Metal

class Bird: GameObject {
    let textureName = "bird"

    var startPos: Vector2 = .zero

    let gravity: Float = 30
    let jumpForce: Float = -1100

    let tiltAngle = Float.pi / 4

    init() {
        super.init(textureName: textureName)
        transform = Transform2D(
            position: startPos,
            angle: 0,
            size: Vector2(x: 34, y: 24),
            scale: 4
        )
    }

    override func update(_ deltaTime: Float, parent _: GameObject? = nil) {
        if InputController.taps > 0 {
            onTap()
        }
        switch Renderer.gameState {
        case .ready:
            transform.position = startPos
        case .playing:
            velocity.y += gravity

            if velocity.y > 50 {
                transform.angle = Float.lerp(transform.angle, -tiltAngle, 0.3)
            } else if velocity.y < -50 {
                transform.angle = Float.lerp(transform.angle, tiltAngle, 0.3)
            } else {
                transform.angle = Float.lerp(transform.angle, 0, 0.3)
            }

            if transform.position.y >= Ground.groundY - transform.size.y * transform.scale * 5 / 8 {
                transform.position.y = Ground.groundY - transform.size.y * transform.scale * 5 / 8
                velocity = .zero
                Renderer.gameState = .gameOver
            }
        case .gameOver:
            break
        }
        super.update(deltaTime, parent: parent)
    }

    func updateScreenSize(_ size: CGSize) {
        startPos = Vector2(x: Float(size.width) / 4, y: Float(size.height) / 2)
    }

    func onTap() {
        switch Renderer.gameState {
        case .ready:
            Renderer.gameState = .playing
        case .playing:
            velocity.y = jumpForce
        default:
            break
        }
        InputController.taps -= 1
    }
}
