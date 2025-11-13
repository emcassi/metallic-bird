//
//  Bird.swift
//  Metallic Bird
//
//  Created by Alex Sigalos on 11/10/25.
//

import MetalKit

enum BirdTexture: String {
    case base = "bird"
    case flapUp = "bird-flap-up"
    case flapDown = "bird-flap-down"
}

class Bird: GameObject {
    let baseTexture: BirdTexture = .base
    let flapUpTexture: BirdTexture = .flapUp
    let flapDownTexture: BirdTexture = .flapDown
    var currentTexture: BirdTexture

    static var startPos: Vector2 = .zero

    let gravity: Float = 40
    let jumpForce: Float = -925

    let tiltAngle = Float.pi / 4

    var minY: Float!
    var maxY: Float!

    let soundboard = Renderer.soundboard

    var isDead: Bool = false
    var isDeathFall: Bool = false

    init() {
        currentTexture = baseTexture
        super.init(textureName: currentTexture.rawValue)

        let transform = Transform2D(
            position: Bird.startPos,
            angle: 0,
            size: Vector2(x: 34, y: 24),
            scale: 4
        )
        self.transform = transform
        updateScreenSize()
        self.transform.position = Bird.startPos
    }

    override func update(_ deltaTime: Float, parent _: GameObject? = nil) {
        if InputController.taps > 0 {
            onTap()
        }
        if Renderer.gameState == .ready {
            transform.position = Bird.startPos
            return
        } else if Renderer.gameState == .dying, !isDead {
            die()
        }

        if velocity.y > 50 {
            transform.angle = Float.lerp(transform.angle, -tiltAngle, 0.3)
            setTexture(.flapUp)
        } else if velocity.y < -50 {
            transform.angle = Float.lerp(transform.angle, tiltAngle, 0.3)
            setTexture(.flapDown)
        } else {
            transform.angle = Float.lerp(transform.angle, 0, 0.3)
            setTexture(.base)
        }

        velocity.y += gravity

        super.update(deltaTime, parent: parent)

        if transform.position.y <= minY {
            transform.position.y = minY
            if !isDead {
                die()
            }
        }

        if transform.position.y >= maxY {
            transform.position.y = maxY
            transform.angle = -tiltAngle
            if !isDead {
                die()
            }

            Renderer.gameState = .gameOver
            return
        }

        if isDead {
            deathFall()
        }
    }

    func updateScreenSize() {
        let size = Vector2(x: Float(Renderer.windowSize.width), y: Float(Renderer.windowSize.height))

        Bird.startPos = Vector2(x: size.x / 4, y: size.y / 2)
        minY = Float(Renderer.safeAreaInsets.top) + transform.size.y * transform.scale
        maxY = Ground.groundY - transform.size.y * transform.scale * 3 / 4
    }

    func setTexture(_ texture: BirdTexture) {
        if texture != currentTexture {
            sprite?.setTexture(name: texture.rawValue, type: BaseColor)
        }
    }

    func onTap() {
        switch Renderer.gameState {
        case .ready:
            Renderer.gameState = .playing
            flap()
        case .playing:
            flap()
        case .dying:
            break
        case .gameOver:
            Renderer.world.reset()
        }
        InputController.taps -= 1
    }

    func flap() {
        velocity.y = jumpForce
        soundboard.play(sfx: .flap)
    }

    func die() {
        Renderer.gameState = .dying
        velocity = .zero
        isDead = true
        soundboard.addToQueue(sfx: .hit)
    }

    func deathFall() {
        if !isDeathFall {
            isDeathFall = true
            soundboard.addToQueue(sfx: .die)
        }
    }
}
