//
//  RepetitionCounter.swift
//  Boxibox
//
//  Created by Roberto García on 15-01-25.
//


import Foundation

class RepetitionCounter {
    private static let defaultEnterThreshold: Double = 6.0
    private static let defaultExitThreshold: Double = 4.0

    let className: String

    var numRepeats: Int
    private var poseEntered: Bool

    init(className: String) {
        self.className = className
        self.numRepeats = 0
        self.poseEntered = false
    }

    func addClassificationResult(_ classificationResult: ClassificationResult) -> Int {
        let poseConfidence = classificationResult.getClassConfidence(for: className)

        if !poseEntered {
            poseEntered = poseConfidence > RepetitionCounter.defaultEnterThreshold
            return numRepeats
        }

        if poseConfidence < RepetitionCounter.defaultExitThreshold {
            numRepeats += 1
            poseEntered = false
        }

        return numRepeats
    }
}
