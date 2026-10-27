//
//  PastryClassifier.swift
//  Pastry Identifier
//

import CoreML
import UIKit
import Vision

// Runs the CoreML model on a photo
struct PastryClassifier {

    // Classify an image; nil if the model fails
    func classify(_ image: UIImage) -> PastryClassification? {
        // Convert image to ciImage for Vision framework compatability
        guard let ciImage = CIImage(image: image) else {
            print("Failed to create CIImage")
            return nil
        }
        do {
            let model = try Pastry_SelectorV6(configuration: MLModelConfiguration())
            let visionModel = try VNCoreMLModel(for: model.model)
            let request = VNCoreMLRequest(model: visionModel)
            // perform runs synchronously, so results are ready after it returns
            try VNImageRequestHandler(ciImage: ciImage, options: [:]).perform([request])
            guard let topResult = (request.results as? [VNClassificationObservation])?.first else {
                print("No results")
                return nil
            }
            return Self.result(for: topResult.identifier, confidence: topResult.confidence)
        } catch {
            print("Error: \(error)")
            return nil
        }
    }

    // Logic for classification displayed
    static func result(for identifier: String, confidence: Float) -> PastryClassification {
        if identifier == "Other" {
            return PastryClassification(name: "Not Applicable", note: "Image not within classification scope.")
        } else if confidence > 0.90 {
            return PastryClassification(name: identifier, note: "High Confidence.")
        } else if confidence > 0.55 {
            return PastryClassification(name: identifier, note: "Low Confidence. May be misclassified")
        } else {
            return PastryClassification(name: "Unclassified", note: "Very Low Confidence. Try different angle")
        }
    }
}
