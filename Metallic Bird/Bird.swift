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
    var textures: [BirdTexture] = [.base, .flapDown, .base, .flapUp]
    var currentTexture: Int = 0

    static var startPos: Vector2 = .zero

    let gravity: Float = 50
    let jumpForce: Float = -950

    let tiltAngle = Float.pi / 4

    var minY: Float!
    var maxY: Float!

    let animationReadyDelay: Float = 0.15
    let animationGameDelay: Float = 0.075
    var animationTimer: Float

    let soundboard = Renderer.soundboard

    var isDead: Bool = false
    var isDeathFall: Bool = false

    #if !DEBUG
        let feedback: UIImpactFeedbackGenerator!
    #endif

    init() {
        animationTimer = animationReadyDelay
        #if !DEBUG
            feedback = UIImpactFeedbackGenerator(view: Renderer.metalView)
        #endif
        super.init(textureName: textures[currentTexture].rawValue)

        let transform = Transform2D(
            position: Bird.startPos,
            angle: 0,
            size: Vector2(x: 34, y: 24),
            scale: 4
        )
        self.transform = transform
        updateScreenSize()
        self.transform.position = Bird.startPos
        #if !DEBUG
            feedback.prepare()
        #endif
    }

    override func update(_ deltaTime: Float, parent _: GameObject? = nil) {
        if InputController.taps > 0 {
            onTap()
        }
        if Renderer.gameState == .ready {
            transform.position = Bird.startPos
            handleAnimation(deltaTime)
            return
        } else if Renderer.gameState == .dying, !isDead {
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
        } else {
            handleAnimation(deltaTime)
        }
    }

    func handleAnimation(_ deltaTime: Float) {
        animationTimer -= deltaTime
        if animationTimer <= 0 {
            currentTexture += 1
            if currentTexture >= textures.count {
                currentTexture = 0
            }
            sprite?.setTexture(name: textures[currentTexture].rawValue, type: BaseColor)
            if Renderer.gameState == .ready {
                animationTimer = animationReadyDelay
            } else {
                animationTimer = animationGameDelay
            }
        }
    }

    func updateScreenSize() {
        let size = Vector2(x: Float(Renderer.windowSize.width), y: Float(Renderer.windowSize.height))

        Bird.startPos = Vector2(x: size.x / 4, y: size.y / 2)
        minY = Float(Renderer.safeAreaInsets.top) + transform.size.y * transform.scale
        maxY = Ground.groundY - transform.size.y * transform.scale * 3 / 4
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
        #if !DEBUG
            feedback.impactOccurred(intensity: 0.5)
        #endif
        soundboard.play(sfx: .flap)
    }

    func die() {
        if !isDead {
            Renderer.gameState = .dying
            velocity = .zero
            isDead = true
            soundboard.addToQueue(sfx: .hit)
            Renderer.deathFlash.setActive()
            #if !DEBUG
                feedback.impactOccurred(intensity: 1)
            #endif
        }
    }

    func deathFall() {
        if !isDeathFall {
            isDeathFall = true
            soundboard.addToQueue(sfx: .die)
        }
    }
}
