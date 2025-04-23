//
//  PoseClassifier.swift
//  Boxibox
//
//  Created by Roberto García on 16-01-25.
//


import Foundation
import MLKit


class PoseClassifier {
    private static let maxDistanceTopK = 30
    private static let meanDistanceTopK = 10
    private static let axesWeights = PointF3D(x: 1, y: 1, z: 0.2)
    private static let deviceOrientation = UIDeviceOrientation.portrait

    private let poseSamples: [PoseSample]
    private let maxDistanceTopK: Int
    private let meanDistanceTopK: Int
    private let axesWeights: PointF3D

    init(poseSamples: [PoseSample]) {
        self.poseSamples = poseSamples
        self.maxDistanceTopK = PoseClassifier.maxDistanceTopK
        self.meanDistanceTopK = PoseClassifier.meanDistanceTopK
        self.axesWeights = PoseClassifier.axesWeights
    }

    init(poseSamples: [PoseSample], maxDistanceTopK: Int, meanDistanceTopK: Int, axesWeights: PointF3D, deviceOrientation: UIDeviceOrientation) {
        self.poseSamples = poseSamples
        self.maxDistanceTopK = maxDistanceTopK
        self.meanDistanceTopK = meanDistanceTopK
        self.axesWeights = axesWeights
    }

    private func extractPoseLandmarks(from pose: Pose) -> [PointF3D] {
        var landmarks = [PointF3D]()
        for poseLandmarkType in LandmarkTypeIndex.allPoseLandmarkTypes {
            let position = pose.landmark(ofType: poseLandmarkType).position
            let isPortrait = PoseClassifier.deviceOrientation == .portrait
            let point = PointF3D(x: Float(isPortrait ? position.y : position.x), y: Float(isPortrait ? position.x : position.y), z: Float(position.z))
            landmarks.append(point)
        }
        return landmarks
    }

    func confidenceRange() -> Int {
        return min(maxDistanceTopK, meanDistanceTopK)
    }

    func classify(pose: Pose) -> ClassificationResult {
        return classify(landmarks: extractPoseLandmarks(from: pose))
    }

    func classify(landmarks: [PointF3D]) -> ClassificationResult {
        let result = ClassificationResult()
        guard !landmarks.isEmpty else { return result }

        let flippedLandmarks = landmarks.map { PointF3D.multiply($0, by: PointF3D(x: -1, y: 1, z: 1)) }
        
        let embedding = PoseEmbedding.getPoseEmbedding(from: landmarks)
        let flippedEmbedding = PoseEmbedding.getPoseEmbedding(from: flippedLandmarks)
        
        var maxDistances = PriorityQueue<(PoseSample, Float)>(
            comparator: { $0.1 > $1.1 }
        )
        
        for poseSample in poseSamples {
            let sampleEmbedding = poseSample.embedding
            
            var originalMax: Float = 0
            var flippedMax: Float = 0
            for i in 0..<embedding.count {
                originalMax = max(originalMax, PointF3D.maxAbs(PointF3D.multiply(PointF3D.subtract(embedding[i], from: sampleEmbedding[i]), by: axesWeights)))
                flippedMax = max(flippedMax, PointF3D.maxAbs(PointF3D.multiply(PointF3D.subtract(flippedEmbedding[i], from: sampleEmbedding[i]), by: axesWeights)))
            }

            maxDistances.add((poseSample, min(originalMax, flippedMax)))
            if (maxDistances.count > maxDistanceTopK) {
                let _ = maxDistances.poll()
            }
        }

        var meanDistances = PriorityQueue<(PoseSample, Float)>(
            comparator: { $0.1 > $1.1 }
        )

        for sampleDistances in maxDistances {
            let poseSample = sampleDistances.0
            let sampleEmbedding = poseSample.embedding

            var originalSum: Float = 0
            var flippedSum: Float = 0

            for i in 0..<embedding.count {
                originalSum += PointF3D.sumAbs(PointF3D.multiply(PointF3D.subtract(embedding[i], from: sampleEmbedding[i]), by: axesWeights))
                flippedSum += PointF3D.sumAbs(PointF3D.multiply(PointF3D.subtract(flippedEmbedding[i], from: sampleEmbedding[i]), by: axesWeights))
            }

            let meanDistance = min(originalSum, flippedSum) / (Float(embedding.count) * 2)

            meanDistances.add((poseSample, meanDistance))
            if (meanDistances.count > meanDistanceTopK) {
                let _ = meanDistances.poll()
            }
        }
    
        for sampleDistances in meanDistances {
            let className = sampleDistances.0.className
            result.incrementClassConfidence(for: className)
        }
        
        return result
    }
}

