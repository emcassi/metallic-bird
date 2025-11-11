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
        addChild(name: "ground", object: World.ground as GameObject)
        addChild(name: "bird", object: World.bird as Bird)
    }

    override func update(_ deltaTime: Float, parent _: GameObject? = nil) {
        super.update(deltaTime)
    }
}
