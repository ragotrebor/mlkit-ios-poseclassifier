//
//  EMASmoothing.swift
//  Boxibox
//
//  Created by Roberto García on 15-01-25.
//


import Foundation

class EMASmoothing {
    private static let defaultWindowSize: Int = 10
    private static let defaultAlpha: Double = 0.2

    private static let resetThresholdMs: Int64 = 100

    private let windowSize: Int
    private let alpha: Double
    private var window: [ClassificationResult] = []
    private var lastInputMs: Int64 = 0

    init() {
        self.windowSize = Self.defaultWindowSize
        self.alpha = Self.defaultAlpha
    }

    init(windowSize: Int, alpha: Double) {
        self.windowSize = windowSize
        self.alpha = alpha
    }

    func getSmoothedResult(classificationResult: ClassificationResult) -> ClassificationResult {
        let nowMs = Int64(Date().timeIntervalSince1970 * 1000)
        if nowMs - lastInputMs > Self.resetThresholdMs {
            window.removeAll()
        }
        lastInputMs = nowMs

        if window.count == windowSize {
            window.removeLast()
        }

        window.insert(classificationResult, at: 0)

        var allClasses = Set<String>()
        for result in window {
            allClasses.formUnion(result.getAllClasses())
        }

        let smoothedResult = ClassificationResult()

        for className in allClasses {
            var factor: Double = 1
            var topSum: Double = 0
            var bottomSum: Double = 0

            for result in window {
                let value = result.getClassConfidence(for: className)
                topSum += factor * value
                bottomSum += factor
                factor *= (1.0 - alpha)
            }

            let smoothedConfidence = topSum / bottomSum
            smoothedResult.putClassConfidence(for: className, confidence: smoothedConfidence)
        }

        return smoothedResult
    }
}
