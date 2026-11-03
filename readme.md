
# Pastries

An iOS app that uses machine learning to identify pastries from photos and helps you find nearby bakeries serving them.

## Features

- **ML-Powered Classification**: Identifies pastries from camera or photo library images with confidence scoring
- **Bakery Finder**: Searches nearby bakeries and cafés that may serve the identified pastry using MapKit
- **Pastry Information**: Displays origin, history, nutrition facts, allergens, and dietary info for each pastry
- **Supported Pastries**:
  - Croissant
  - Cookie
  - Kouign Amann
  - Danish
  - Scone

## Technical Highlights

- Custom `Pastry_SelectorV6` model trained and deployed using CoreML (92% Test Accuracy)
- Vision framework (`VNCoreMLRequest`) for image classification pipeline
- Custom AVFoundation camera with SwiftUI tab-based navigation (iOS 26+)
- Nutrition and allergen data from FatSecret via a hosted proxy
- MapKit integration with `MKLocalSearch` for location-based bakery discovery
- PhotosUI for photo library selection

### Showcase
[![Watch the video](https://img.youtube.com/vi/Y7515-p1G78/maxresdefault.jpg)](https://www.youtube.com/watch?v=Y7515-p1G78)
