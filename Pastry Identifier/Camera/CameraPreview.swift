//
//  CameraPreview.swift
//  Pastry Identifier
//
//  Shows the live camera feed. SwiftUI has no camera view, so this wraps UIKit.
//

import AVFoundation
import SwiftUI

struct CameraPreview: UIViewRepresentable {
    let session: AVCaptureSession

    func makeUIView(context: Context) -> PreviewView {
        let view = PreviewView()
        view.previewLayer.session = session
        view.previewLayer.videoGravity = .resizeAspectFill // Fill the screen
        return view
    }

    func updateUIView(_ uiView: PreviewView, context: Context) {}

    // A view whose layer is the preview, so it resizes with the view
    class PreviewView: UIView {
        override class var layerClass: AnyClass { AVCaptureVideoPreviewLayer.self }
        var previewLayer: AVCaptureVideoPreviewLayer { layer as! AVCaptureVideoPreviewLayer }
    }
}
