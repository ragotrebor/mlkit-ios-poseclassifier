# 📱 ML Kit Pose Classification on iOS

## 📍 Integration Overview

The `PoseClassifierProcessor` serves as the entry point for the classification module and is referenced inside `CameraViewController.swift`.

When the `Detector.poseClassifier` option is selected in the UI’s detector picker, the class is instantiated. Its `detectPose(in image: MLImage...)` method processes the results of the pose detection system and forwards them for classification.

## 📥 Installation

1. Clone the repo.
2. Open the Xcode project.
3. Install dependencies (e.g. via CocoaPods or Swift Package Manager):
   ```bash
   pod install
