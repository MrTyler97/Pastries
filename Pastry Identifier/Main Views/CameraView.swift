//
//  CameraView.swift
//  Camera Examples
//
//  Created by Vic  on 5/22/25.
//

// Use this template for other projects
import Foundation
import SwiftUI
import UIKit

/* Important Comments:

SwiftUI’s UIViewControllerRepresentable protocol doesn’t directly support UIKit delegate methods, so you supply a “coordinator” object that is a delegate.

A delegate is an object that implements certain methods to handle events. Here, UIImagePickerControllerDelegate methods let us react when the user takes a photo or cancels.


1) Parent SwiftUI view presents CameraView(image: $selectedImage) in a .sheet.

2) SwiftUI calls makeUIViewController, giving you a live UIImagePickerController.

3) You supply a Coordinator as its delegate.

4) When the user snaps a photo (or cancels), the delegate methods in your coordinator fire, sending the image data back into your SwiftUI state and dismissing the modal.

5) SwiftUI automatically updates any views depending on that @Binding image. */

struct CameraView: UIViewControllerRepresentable {
    @Binding var image: UIImage? // bind to parent view state
    @Environment(\.presentationMode) var presentationMode // dismiss view
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController() // create camera picker
        picker.delegate = context.coordinator // set coordinator as delegate
        picker.sourceType = .camera
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
      // No update
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: CameraView
        
        init(_ parent: CameraView) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.image = image // pass selected imahe to the parent
            }
            parent.presentationMode.wrappedValue.dismiss() // dismiss the picker
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss() // dismiss on cancel
        }
    }
}


