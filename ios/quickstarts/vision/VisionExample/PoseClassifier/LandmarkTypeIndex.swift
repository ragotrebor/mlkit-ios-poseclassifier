//
//  LandmarkTypeIndex.swift
//  Boxibox
//
//  Created by Roberto García on 17-01-25.
//

import MLKit

enum LandmarkTypeIndex: Int {
    case nose = 0
    case leftEyeInner = 1
    case leftEye = 2
    case leftEyeOuter = 3
    case rightEyeInner = 4
    case rightEye = 5
    case rightEyeOuter = 6
    case leftEar = 7
    case rightEar = 8
    case leftMouth = 9
    case rightMouth = 10
    case leftShoulder = 11
    case rightShoulder = 12
    case leftElbow = 13
    case rightElbow = 14
    case leftWrist = 15
    case rightWrist = 16
    case leftPinky = 17
    case rightPinky = 18
    case leftIndex = 19
    case rightIndex = 20
    case leftThumb = 21
    case rightThumb = 22
    case leftHip = 23
    case rightHip = 24
    case leftKnee = 25
    case rightKnee = 26
    case leftAnkle = 27
    case rightAnkle = 28
    case leftHeel = 29
    case rightHeel = 30
    case leftFootIndex = 31
    case rightFootIndex = 32
    
    static let allPoseLandmarkTypes: [PoseLandmarkType] = [
        .nose,
        .leftEyeInner,
        .leftEye,
        .leftEyeOuter,
        .rightEyeInner,
        .rightEye,
        .rightEyeOuter,
        .leftEar,
        .rightEar,
        .mouthLeft,
        .mouthRight,
        .leftShoulder,
        .rightShoulder,
        .leftElbow,
        .rightElbow,
        .leftWrist,
        .rightWrist,
        .leftPinkyFinger,
        .rightPinkyFinger,
        .leftIndexFinger,
        .rightIndexFinger,
        .leftThumb,
        .rightThumb,
        .leftHip,
        .rightHip,
        .leftKnee,
        .rightKnee,
        .leftAnkle,
        .rightAnkle,
        .leftHeel,
        .rightHeel,
        .leftToe,
        .rightToe
    ]
}

extension Array {
    subscript(landmark: LandmarkTypeIndex) -> Element {
        return self[landmark.rawValue]
    }
}
