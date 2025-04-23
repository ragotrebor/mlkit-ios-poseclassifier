# 📱 ML Kit Pose Classification on iOS

This project brings pose classification to iOS using [Google's ML Kit Pose Detection](https://developers.google.com/ml-kit/vision/pose-detection). It reimplements the [pose classification logic](https://developers.google.com/ml-kit/vision/pose-detection/classifying-poses) (including the KNN algorithm) from the official Android sample project, filling the gap left by the lack of an iOS counterpart.


## 📂 Quickstart

This project is based on a fork of [googlesamples/mlkit](https://github.com/googlesamples/mlkit), focused on pose classification.

You can explore the relevant iOS implementation in this subfolder:  
👉 [ios/quickstarts/vision](https://github.com/ragotrebor/mlkit-ios-poseclassifier/tree/master/ios/quickstarts/vision)

## 🎯 Features

- Real-time human pose detection using ML Kit.
- K-Nearest Neighbors (KNN)-based pose classification.
- Custom pose embedding inspired by the Android example.
- Modular and extensible Swift implementation.

## 📍 Integration Overview

The `PoseClassifierProcessor` serves as the entry point for the classification module and is referenced inside `CameraViewController.swift`.

When the `Detector.poseClassifier` option is selected in the UI’s detector picker, the class is instantiated. Its `detectPose(in image: MLImage...)` method processes the results of the pose detection system and forwards them for classification.

## 📥 Installation

1. Clone the repo.
2. Open the Xcode project.
3. Install dependencies (e.g. via CocoaPods or Swift Package Manager):
   ```bash
   pod install
