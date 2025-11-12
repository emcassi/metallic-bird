//
//  ScoreDigit.swift
//  Metallic Bird
//
//  Created by Alex Sigalos on 11/12/25.
//

class ScoreDigit: GameObject {
    let size = Vector2(x: 24, y: 36)
    let scale: Float = 2

    init(digit: Character) {
        let textureName = String(digit)

        super.init(textureName: textureName)
        transform.size = size
        transform.scale = scale
    }
}
