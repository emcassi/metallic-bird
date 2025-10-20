//
//  Matrix.swift
//  Metallic Bird
//
//  Created by Alex Sigalos on 10/20/25.
//

extension float4x4 {
    static let identity = matrix_identity_float4x4

    init(matrix: simd_float4x4) {
        self.init(
            [
                matrix.columns.0,
                matrix.columns.1,
                matrix.columns.2,
                matrix.columns.3,
            ]
        )
    }

    init(translateX: Float, translateY: Float) {
        var matrix = matrix_identity_float4x4
        matrix.columns.3 = [translateX, translateY, 0, 1]

        self.init(matrix: matrix)
    }

    init(scale: Float) {
        var matrix = matrix_identity_float4x4
        matrix.columns.0.x = scale
        matrix.columns.1.y = scale

        self.init(matrix: matrix)
    }

    init(scaleX: Float, scaleY: Float) {
        var matrix = matrix_identity_float4x4
        matrix.columns.0.x = scaleX
        matrix.columns.1.y = scaleY

        self.init(matrix: matrix)
    }

    static func ortho(left: Float,
                      right: Float,
                      bottom: Float,
                      top: Float,
                      near: Float,
                      far: Float) -> simd_float4x4
    {
        let scaleX: Float = 2 / (right - left)
        let scaleY: Float = 2 / (top - bottom)
        let scaleZ: Float = 1 / (far - near)

        let transX: Float = -(left + right) / (right - left)
        let transY: Float = -(bottom + top) / (top - bottom)
        let transZ: Float = near / (near - far)

        let matrix = float4x4.init(columns: (
            SIMD4<Float>(scaleX, 0, 0, 0),
            SIMD4<Float>(0, scaleY, 0, 0),
            SIMD4<Float>(0, 0, scaleZ, 0),
            SIMD4<Float>(transX, transY, transZ, 1)
        ))
        return matrix
    }
}
