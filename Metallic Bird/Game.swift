//
//  Game.swift
//  Metallic Bird
//
//  Created by Alex Sigalos on 11/14/25.
//

import MetalKit

class Game {
    static var world: World = .init()
    static var soundboard: Soundboard = .init()

    static var gameState: GameState = .ready

    static let deathFlash: DeathFlash = .init()

    static var hapticGenerator: UIImpactFeedbackGenerator = .init()

    init(metalView: MTKView) {
        #if !DEBUG
            Self.hapticGenerator = UIImpactFeedbackGenerator(view: metalView)
            Self.hapticGenerator.prepare()
        #endif
    }

    func update(_ deltaTime: Float) {
        Self.world.update(deltaTime)
        Self.soundboard.queueUpdate()
        Self.deathFlash.update(deltaTime)
    }
}
