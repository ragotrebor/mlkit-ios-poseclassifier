//
//  PointF3D.swift
//  Boxibox
//
//  Created by Roberto García on 14-01-25.
//

import Foundation
import MLKit

struct PointF3D: Hashable {
    let x: Float
    let y: Float
    let z: Float

    // Initializer
    init(x: Float, y: Float, z: Float) {
        self.x = x
        self.y = y
        self.z = z
    }

    // Custom string representation
    var description: String {
        return "PointF3D{x=\(x), y=\(y), z=\(z)}"
    }

    // Equality check (Equatable conformance)
    static func ==(lhs: PointF3D, rhs: PointF3D) -> Bool {
        return lhs.x == rhs.x &&
               lhs.y == rhs.y &&
               lhs.z == rhs.z
    }
    
    static func add(_ a: PointF3D,_ b: PointF3D) -> PointF3D {
        return PointF3D(x: a.x + b.x, y: a.y + b.y, z: a.z + b.z)
    }

    static func subtract(_ b: PointF3D, from a: PointF3D) -> PointF3D {
        return PointF3D(x: a.x - b.x, y: a.y - b.y, z: a.z - b.z)
    }

    static func multiply(_ a: PointF3D, by scalar: Float) -> PointF3D {
        return PointF3D(x: a.x * scalar, y: a.y * scalar, z: a.z * scalar)
    }

    static func multiply(_ a: PointF3D, by b: PointF3D) -> PointF3D {
        return PointF3D(x: a.x * b.x, y: a.y * b.y, z: a.z * b.z)
    }

    static func average(_ a: PointF3D, _ b: PointF3D) -> PointF3D {
        return PointF3D(x: (a.x + b.x) * 0.5, y: (a.y + b.y) * 0.5, z: (a.z + b.z) * 0.5)
    }

    static func l2Norm2D(_ point: PointF3D) -> Float {
        return hypot(point.x, point.y)
    }

    static func maxAbs(_ point: PointF3D) -> Float {
        return max(abs(point.x), abs(point.y), abs(point.z))
    }

    static func sumAbs(_ point: PointF3D) -> Float {
        return abs(point.x) + abs(point.y) + abs(point.z)
    }

}

