//
//  Math.swift
//  Metallic Bird
//
//  Created by Alex Sigalos on 11/11/25.
//

extension Float {
    static func lerp(_ current: Float, _ target: Float, _ factor: Float) -> Float {
        return current * (1.0 - factor) + (target * factor)
    }
}
