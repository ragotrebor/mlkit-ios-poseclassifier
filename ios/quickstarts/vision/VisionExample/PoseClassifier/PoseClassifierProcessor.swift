//
//  PoseClassifierProcessor.swift
//  Boxibox
//
//  Created by Roberto García on 16-01-25.
//

import MLKit

import Foundation
import AVFoundation

class PoseClassifierProcessor {
    private let poseSamplesFile = "fitness_pose_samples.csv"
    private let boxSamplesFile = "boxing_pose_samples.csv"

    private let poseClasses = ["pushups_down", "squats_down"]

    private var emaSmoothing: EMASmoothing?
    private var repCounters = [RepetitionCounter]()
    private var poseClassifier: PoseClassifier?
    private var lastRepResult = ""

    init() {
        self.emaSmoothing = EMASmoothing()
        self.repCounters = poseClasses.map { RepetitionCounter(className: $0) }
        self.lastRepResult = ""
        loadPoseSamples()
    }

    private func loadPoseSamples() {
        var poseSamples = [PoseSample]()
        guard let fitnessPath = Bundle.main.path(forResource: poseSamplesFile, ofType: nil) else {
            print("Error: Unable to locate pose samples file.")
            return
        }

        do {
            let fileContents = try String(contentsOfFile: fitnessPath, encoding: .utf8)
            let lines = fileContents.split { $0.isNewline }
            for line in lines {
                if let poseSample = PoseSample.getPoseSample(from: String(line), separator: ",") {
                    poseSamples.append(poseSample)
                }
            }
        } catch {
            print("Error when loading fitness pose samples: \(error.localizedDescription)")
        }

        poseClassifier = PoseClassifier(poseSamples: poseSamples)
    }


    func getPoseResult(pose: Pose) -> PoseResult {
        var poseResult = PoseResult(lastRepResult: "", confidenceResult: "")
        guard var classification = poseClassifier?.classify(pose: pose) else { return poseResult }
        classification = emaSmoothing?.getSmoothedResult(classificationResult: classification) ?? classification

        if pose.landmarks.isEmpty {
            poseResult.lastRepResult = lastRepResult
            return poseResult
        }

        for repCounter in repCounters {
            let repsBefore = repCounter.numRepeats
            let repsAfter = repCounter.addClassificationResult(classification)
            if repsAfter > repsBefore, let maxConfidenceClass = classification.getMaxConfidenceClass() {
                // TODO: Play a beep when rep counter updates.
                lastRepResult = String(format: "%@: %d reps", maxConfidenceClass, repsAfter)
                break
            }
        }
        poseResult.lastRepResult = lastRepResult
        
        if !pose.landmarks.isEmpty, let maxConfidenceClass = classification.getMaxConfidenceClass(), let poseClassifier = poseClassifier {
            let confidence = classification.getClassConfidence(for: maxConfidenceClass)
            let confidenceResult = String(format: "%@: %.2f confidence", maxConfidenceClass, confidence / Double(poseClassifier.confidenceRange()))
            poseResult.confidenceResult = confidenceResult
        }
        
        return poseResult
    }
}

struct PoseResult {
    var lastRepResult: String
    var confidenceResult: String
}

