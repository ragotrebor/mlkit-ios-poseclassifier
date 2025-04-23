//
//  ClassificationResult.swift
//  Boxibox
//
//  Created by Roberto García on 15-01-25.
//


import Foundation

class ClassificationResult {
    private var classConfidences: [String: Double] = [:]

    init() {}
    
    func getClassConfidencesDescription() -> String {
        return classConfidences.debugDescription
    }

    func getAllClasses() -> Set<String> {
        return Set(classConfidences.keys)
    }

    func getClassConfidence(for className: String) -> Double {
        return classConfidences[className] ?? 0
    }

    func getMaxConfidenceClass() -> String? {
        return classConfidences.max { $0.value < $1.value }?.key
    }

    func incrementClassConfidence(for className: String) {
        classConfidences[className, default: 0] += 1
    }

    func putClassConfidence(for className: String, confidence: Double) {
        classConfidences[className] = confidence
    }

}

