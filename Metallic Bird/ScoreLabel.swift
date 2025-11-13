//
//  ScoreLabel.swift
//  Metallic Bird
//
//  Created by Alex Sigalos on 11/12/25.
//

import Foundation

class ScoreLabel: GameObject {
    var center: Vector2 = .zero
    let digitSize: Vector2 = .init(x: 24, y: 36)
    let padding: Float = 4
    let scale: Float = 2

    init() {
        super.init()

        updateLabel()

        updateScreenSize()
    }

    func updateLabel() {
        let digits = ScoreController.getDigits()
        children.removeAll(keepingCapacity: true)
        childrenNames.removeAll(keepingCapacity: true)
        for digit in digits {
            addChild(name: "digit-\(UUID().uuidString)", object: ScoreDigit(digit: digit))
        }
        align()
    }

    func updateScreenSize() {
        center = Vector2(x: Float(Renderer.windowSize.width) / 2, y: 300)
        transform = Transform2D(
            position: Vector2(x: center.x, y: center.y),
            angle: 0,
            size: digitSize,
            scale: scale
        )
        align()
    }

    func align() {
        let top: Float = center.y - digitSize.y / 2
        let width: Float = scale * digitSize.x * Float(children.count) + padding * Float(children.count - 1)
        let left: Float = center.x - width

        transform = Transform2D(
            position: Vector2(x: left, y: top),
            angle: 0,
            size: Vector2(x: width, y: digitSize.y),
            scale: scale
        )

        alignChildren()
    }

    func alignChildren() {
        for index in 0 ..< childrenNames.count {
            let name = childrenNames[index]
            if let child = children[name] {
                child.transform.position.x =
                    (digitSize.x * child.transform.scale * 2 * Float(index)) + padding * Float(index) * scale
            }
        }
    }
}
