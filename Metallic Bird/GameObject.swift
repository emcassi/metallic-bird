//
//  GameObject.swift
//  Metallic Bird
//
//  Created by Alex Sigalos on 11/11/25.
//

import Metal

class GameObject {
    var transform: Transform2D = .init()
    var sprite: Sprite?
    var velocity: Vector2 = .zero

    var parent: GameObject?
    var childrenNames: [String] = []
    var children: [String: GameObject] = [:]

    init(textureName: String? = nil) {
        if let textureName = textureName {
            sprite = Sprite()
            sprite?.setTexture(name: textureName, type: BaseColor)
        }
    }

    func setTexture(name: String, type: TextureIndices) {
        sprite?.setTexture(name: name, type: type)
    }

    func addChild(name: String, object: GameObject) {
        object.parent = self
        children[name] = object
        childrenNames.append(name)
    }

    func child(name: String) -> GameObject? {
        return children[name]
    }

    func update(_ deltaTime: Float, parent _: GameObject? = nil) {
        transform.position += velocity * deltaTime
        sprite?.transform = transform

        for name in childrenNames {
            if let child = children[name] {
                child.update(deltaTime, parent: self)
            }
        }
    }

    func applyParentTransform() -> Transform2D {
        var transform = self.transform
        if let parent = parent {
            transform.position.x += parent.transform.position.x
            transform.position.y += parent.transform.position.y
            transform.angle += parent.transform.angle
            transform.scale *= parent.transform.scale
        }
        return transform
    }

    func draw(renderEncoder: MTLRenderCommandEncoder) {
        sprite?.transform = applyParentTransform()
        sprite?.draw(renderEncoder: renderEncoder)

        for name in childrenNames {
            if let child = children[name] {
                child.draw(renderEncoder: renderEncoder)
            }
        }
    }
}
