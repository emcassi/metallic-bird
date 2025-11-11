//
//  PipeSpawner.swift
//  Metallic Bird
//
//  Created by Alex Sigalos on 11/10/25.
//

import Metal

class PipeSpawner: GameObject {
    var pipes: [String] = []
    let spawnDelay: Float = 1.25
    var spawnTimer: Float

    init() {
        spawnTimer = spawnDelay
        super.init()
    }

    override func update(_ deltaTime: Float, parent _: GameObject? = nil) {
        if Renderer.gameState != .playing {
            return
        }

        super.update(deltaTime, parent: parent)

        spawnTimer -= deltaTime
        if spawnTimer <= 0 {
            spawnPipe()
            spawnTimer = spawnDelay
        }

        if let firstKey = pipes.first, let firstPipe = children[firstKey] {
            if firstPipe is Pipe {
                // swiftlint:disable:next force_cast
                if (children[firstKey] as! Pipe).shouldDelete() {
                    children.removeValue(forKey: firstKey)
                    pipes.removeFirst()
                }
            }
        }
    }

    func spawnPipe() {
        let name = "pipe\(UUID())"
        addChild(name: name, object: Pipe())
        pipes.append(name)
    }
}
