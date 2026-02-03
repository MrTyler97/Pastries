
# Pastries

An iOS app that uses machine learning to identify pastries from photos and helps you find nearby bakeries serving them.

## Features

- **ML-Powered Classification**: Identifies pastries from camera or photo library images with confidence scoring
- **Bakery Finder**: Searches nearby bakeries and cafés that may serve the identified pastry using MapKit
- **Pastry Information**: Displays origin, history, and allergen warnings for each pastry
- **Supported Pastries**:
  - Croissant
  - Cookie
  - Kouign Amann
  - Danish
  - Scone

## Technical Highlights

- Custom `Pastry_SelectorV6` model trained and deployed using CoreML (92% Test Accuracy)
- Vision framework (`VNCoreMLRequest`) for image classification pipeline
- SwiftUI with UIKit interop via `UIViewControllerRepresentable` for camera access
- MapKit integration with `MKLocalSearch` for location-based bakery discovery
- PhotosUI for photo library selection
