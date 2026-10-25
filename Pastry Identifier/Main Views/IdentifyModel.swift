//
//  IdentifyModel.swift
//  Pastry Identifier
//

import SwiftUI
import PhotosUI

// Shared identify state so Home and Identify tabs drive the same flow
@Observable
final class IdentifyModel {
    // holds selected photo Item
    var selectedItem: PhotosPickerItem?
    // Hold loaded image
    var selectedImage: UIImage?
    // Camera cover visability
    var showingCamera = false
    // Photo picker visability
    var showingPicker = false
    // Result sheet viewability
    var showingResult = false
    // Classification Name
    var imageName = ""
    // Classification note
    var note = ""

    // Load raw data of picked photo then convert it
    func load(_ item: PhotosPickerItem?) async {
        guard let item else { return }
        if let data = try? await item.loadTransferable(type: Data.self), let image = UIImage(data: data) {
            selectedImage = image
        }
        // Reset so picking the same photo again still triggers a change
        selectedItem = nil
    }

    // Classify the current photo and open the result sheet
    func identify() {
        guard let selectedImage else { return }
        let result = PastryClassifier().classify(selectedImage)
            ?? PastryClassification(name: "Unclassified", note: "Something went wrong - try again")
        imageName = result.name
        note = result.note
        showingResult = true
    }
}
