//
//  CameraService.swift
//  Pastry Identifier
//
//  Runs the back camera and takes photos.
//

// AVCaptureSession is safe to start/stop off the main thread, but isn't marked Sendable
@preconcurrency import AVFoundation
import UIKit

@Observable
class CameraService: NSObject, AVCapturePhotoCaptureDelegate {
    // Live camera feed, shown by CameraPreview
    let session = AVCaptureSession()
    // False when permission is denied or there's no camera (e.g. Simulator)
    var isAvailable = true

    private let photoOutput = AVCapturePhotoOutput()
    // Hands the photo back to takePhoto() when the delegate fires
    private var photoContinuation: CheckedContinuation<UIImage?, Never>?

    // Ask permission, connect the back camera, start the feed
    func start() async {
        guard await AVCaptureDevice.requestAccess(for: .video) else {
            isAvailable = false
            return
        }
        // Already set up (view reappeared)
        if session.inputs.isEmpty {
            guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
                  let input = try? AVCaptureDeviceInput(device: camera),
                  session.canAddInput(input),
                  session.canAddOutput(photoOutput) else {
                isAvailable = false
                return
            }
            session.beginConfiguration()
            session.sessionPreset = .photo
            session.addInput(input)
            session.addOutput(photoOutput)
            session.commitConfiguration()
        }
        // startRunning blocks, so keep it off the main thread
        DispatchQueue.global(qos: .userInitiated).async { [session] in
            session.startRunning()
        }
    }

    func stop() {
        DispatchQueue.global(qos: .userInitiated).async { [session] in
            session.stopRunning()
        }
    }

    func takePhoto() async -> UIImage? {
        // Ignore taps while a photo is in progress
        guard photoContinuation == nil else { return nil }
        return await withCheckedContinuation { continuation in
            photoContinuation = continuation
            photoOutput.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
        }
    }

    // Called on a background thread, so hop back to the main actor
    nonisolated func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        let image = photo.fileDataRepresentation().flatMap { UIImage(data: $0) }
        Task { @MainActor in
            self.photoContinuation?.resume(returning: image)
            self.photoContinuation = nil
        }
    }
}
