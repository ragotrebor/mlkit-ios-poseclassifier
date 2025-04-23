//
//  PoseEmbedding.swift
//  Boxibox
//
//  Created by Roberto García on 17-01-25.
//


struct PoseEmbedding {
    private static let torsoMultiplier: Float = 2.5
    
    static func getPoseEmbedding(from landmarks: [PointF3D]) -> [PointF3D] {
        let normalizedLandmarks = normalizeLandmarks(landmarks)
        return getEmbedding(from: normalizedLandmarks)
    }
    
    
    private static func normalizeLandmarks(_ landmarks: [PointF3D]) -> [PointF3D] {
        let center = PointF3D.average(landmarks[.leftHip], landmarks[.rightHip])
        var normalizedLandmarks = landmarks.map { PointF3D.subtract(center, from: $0) }
        
        let poseSize = getPoseSize(normalizedLandmarks)
        normalizedLandmarks = normalizedLandmarks.map { PointF3D.multiply($0, by: 1 / poseSize) }
        
        normalizedLandmarks = normalizedLandmarks.map { PointF3D.multiply($0, by: 100) }
        return normalizedLandmarks
    }
    
    private static func getPoseSize(_ landmarks: [PointF3D]) -> Float {
        let hipsCenter = PointF3D.average(landmarks[.leftHip], landmarks[.rightHip])
        let shouldersCenter = PointF3D.average(landmarks[.leftShoulder], landmarks[.rightShoulder])
        let torsoSize = PointF3D.l2Norm2D(PointF3D.subtract(hipsCenter, from: shouldersCenter))
        
        var maxDistance = torsoSize * torsoMultiplier
        for landmark in landmarks {
            let distance = PointF3D.l2Norm2D(PointF3D.subtract(hipsCenter, from: landmark))
            if distance > maxDistance {
                maxDistance = distance
            }
        }
        return maxDistance
    }

    private static func getEmbedding(from landmarks: [PointF3D]) -> [PointF3D] {
        var embedding: [PointF3D] = []
        
        // One joint distances
        embedding.append(
            PointF3D.subtract(
                PointF3D.average(landmarks[.leftHip], landmarks[.rightHip]),
                from: PointF3D.average(landmarks[.leftShoulder], landmarks[.rightShoulder])
            )
        )
        embedding.append(PointF3D.subtract(landmarks[.leftShoulder], from: landmarks[.leftElbow]))
        embedding.append(PointF3D.subtract(landmarks[.rightShoulder], from: landmarks[.rightElbow]))
        embedding.append(PointF3D.subtract(landmarks[.leftElbow], from: landmarks[.leftWrist]))
        embedding.append(PointF3D.subtract(landmarks[.rightElbow], from: landmarks[.rightWrist]))
        embedding.append(PointF3D.subtract(landmarks[.leftHip], from: landmarks[.leftKnee]))
        embedding.append(PointF3D.subtract(landmarks[.rightHip], from: landmarks[.rightKnee]))
        embedding.append(PointF3D.subtract(landmarks[.leftKnee], from: landmarks[.leftAnkle]))
        embedding.append(PointF3D.subtract(landmarks[.rightKnee], from: landmarks[.rightAnkle]))

        // Two joint distances
        embedding.append(PointF3D.subtract(landmarks[.leftShoulder], from: landmarks[.leftWrist]))
        embedding.append(PointF3D.subtract(landmarks[.rightShoulder], from: landmarks[.rightWrist]))
        embedding.append(PointF3D.subtract(landmarks[.leftHip], from: landmarks[.leftAnkle]))
        embedding.append(PointF3D.subtract(landmarks[.rightHip], from: landmarks[.rightAnkle]))

        // Four joint distances
        embedding.append(PointF3D.subtract(landmarks[.leftHip], from: landmarks[.leftWrist]))
        embedding.append(PointF3D.subtract(landmarks[.rightHip], from: landmarks[.rightWrist]))

        // Five joint distances
        embedding.append(PointF3D.subtract(landmarks[.leftShoulder], from: landmarks[.leftAnkle]))
        embedding.append(PointF3D.subtract(landmarks[.rightShoulder], from: landmarks[.rightAnkle]))
        embedding.append(PointF3D.subtract(landmarks[.leftHip], from: landmarks[.leftWrist]))
        embedding.append(PointF3D.subtract(landmarks[.rightHip], from: landmarks[.rightWrist]))

        // Cross-body distances
        embedding.append(PointF3D.subtract(landmarks[.leftElbow], from: landmarks[.rightElbow]))
        embedding.append(PointF3D.subtract(landmarks[.leftKnee], from: landmarks[.rightKnee]))
        embedding.append(PointF3D.subtract(landmarks[.leftWrist], from: landmarks[.rightWrist]))
        embedding.append(PointF3D.subtract(landmarks[.leftAnkle], from: landmarks[.rightAnkle]))

        return embedding
    }

}



