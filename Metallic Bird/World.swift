//
//  World.swift
//  Metallic Bird
//
//  Created by Alex Sigalos on 11/11/25.
//

class World: GameObject {
    static let ground = Ground()
    static let bird = Bird()
    let names = ["background", "pipeSpawner", "ground", "bird"]
    init() {
        super.init()

        addChild(name: "background", object: Background() as GameObject)
        addChild(name: "pipeSpawner", object: PipeSpawner() as GameObject)
        addChild(name: "ground", object: Ground() as GameObject)
        addChild(name: "bird", object: Bird() as Bird)
    }

    override func update(_ deltaTime: Float, parent _: GameObject? = nil) {
        super.update(deltaTime)
    }

    func reset() {
        children.removeAll(keepingCapacity: true)
        childrenNames.removeAll(keepingCapacity: true)

        addChild(name: "background", object: Background() as GameObject)
        addChild(name: "pipeSpawner", object: PipeSpawner() as GameObject)
        addChild(name: "ground", object: Ground() as GameObject)
        addChild(name: "bird", object: Bird() as Bird)

        Renderer.gameState = .ready
    }
}
