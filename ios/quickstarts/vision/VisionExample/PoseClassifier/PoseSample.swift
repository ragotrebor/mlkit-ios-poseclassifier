//
//  PoseSample.swift
//  Boxibox
//
//  Created by Roberto García on 16-01-25.
//


import Foundation

class PoseSample {
    private static let numLandmarks = 33
    private static let numDims = 3

    let name: String
    let className: String
    let embedding: [PointF3D]

    init(name: String, className: String, landmarks: [PointF3D]) {
        self.name = name
        self.className = className
        self.embedding = PoseEmbedding.getPoseEmbedding(from: landmarks)
    }


    static func getPoseSample(from csvLine: String, separator: String) -> PoseSample? {
        let tokens = csvLine.split(separator: Character(separator)).map { String($0) }
        
        guard tokens.count == (numLandmarks * numDims) + 2 else {
            print("Invalid number of tokens for PoseSample")
            return nil
        }

        let name = tokens[0]
        let className = tokens[1]
        var landmarks: [PointF3D] = []

        for i in stride(from: 2, to: tokens.count, by: numDims) {
            guard let x = Float(tokens[i]),
                  let y = Float(tokens[i + 1]),
                  let z = Float(tokens[i + 2]) else {
                print("Invalid value \(tokens[i]) for landmark position.")
                return nil
            }
            landmarks.append(PointF3D(x: x, y: y, z: z))
        }
        
        return PoseSample(name: name, className: className, landmarks: landmarks)
    }
}


