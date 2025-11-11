//
//  Vector2.swift
//  Metallic Bird
//
//  Created by Alex Sigalos on 11/10/25.
//

struct Vector2 {
    // swiftlint:disable:next variable_name
    var x: Float
    // swiftlint:disable:next variable_name
    var y: Float
}

extension Vector2 {
    func toSIMD() -> SIMD2<Float> {
        return SIMD2<Float>(x, y)
    }

    static let zero = Vector2(x: 0, y: 0)
    static let one = Vector2(x: 1, y: 1)

    static func + (lhs: Vector2, rhs: Vector2) -> Vector2 {
        return Vector2(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }

    static func += (lhs: inout Vector2, rhs: Vector2) {
        lhs.x += rhs.x
        lhs.y += rhs.y
    }

    static func * (lhs: Vector2, rhs: Float) -> Vector2 {
        return Vector2(x: lhs.x * rhs, y: lhs.y * rhs)
    }
}
