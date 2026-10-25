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
    // Flash setting used for the next photo
    var flashMode: AVCaptureDevice.FlashMode = .off
    // False on devices without a flash
    var hasFlash = false
    // Current digital zoom, 1 = no zoom
    var zoomFactor: CGFloat = 1
    // Upper zoom limit; digital zoom past this gets blurry
    static let maxZoom: CGFloat = 5

    private let photoOutput = AVCapturePhotoOutput()
    // All session work runs here, off the main thread
    private let sessionQueue = DispatchQueue(label: "camera.session")
    // Back camera, kept for zoom changes
    private var device: AVCaptureDevice?
    // Hands the photo back to takePhoto() when the delegate fires
    private var photoContinuation: CheckedContinuation<UIImage?, Never>?

    // Ask permission, then set up and start the camera off the main thread
    func start() async {
        guard await AVCaptureDevice.requestAccess(for: .video) else {
            isAvailable = false
            return
        }
        guard let camera = await configureAndRun() else {
            isAvailable = false
            return
        }
        device = camera
        hasFlash = photoOutput.supportedFlashModes.contains(.on)
    }

    // Session setup blocks for a moment, so it runs on sessionQueue; nil if no camera
    private func configureAndRun() async -> AVCaptureDevice? {
        await withCheckedContinuation { continuation in
            sessionQueue.async { [session, photoOutput] in
                // Already set up (view reappeared)
                if let input = session.inputs.first as? AVCaptureDeviceInput {
                    session.startRunning()
                    continuation.resume(returning: input.device)
                    return
                }
                guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
                      let input = try? AVCaptureDeviceInput(device: camera),
                      session.canAddInput(input),
                      session.canAddOutput(photoOutput) else {
                    continuation.resume(returning: nil)
                    return
                }
                session.beginConfiguration()
                session.sessionPreset = .photo
                session.addInput(input)
                session.addOutput(photoOutput)
                session.commitConfiguration()
                session.startRunning()
                continuation.resume(returning: camera)
            }
        }
    }

    // Same queue as start, so a stop can't run before setup finishes
    func stop() {
        sessionQueue.async { [session] in
            session.stopRunning()
        }
    }

    func takePhoto() async -> UIImage? {
        // Ignore taps while a photo is in progress
        guard photoContinuation == nil else { return nil }
        let settings = AVCapturePhotoSettings()
        // Only use flash modes this camera supports
        if photoOutput.supportedFlashModes.contains(flashMode) {
            settings.flashMode = flashMode
        }
        return await withCheckedContinuation { continuation in
            photoContinuation = continuation
            photoOutput.capturePhoto(with: settings, delegate: self)
        }
    }

    // Zoom the camera, kept within the allowed range
    func setZoom(_ factor: CGFloat) {
        guard let device else { return }
        let zoom = Self.clampedZoom(factor, deviceMax: device.maxAvailableVideoZoomFactor)
        do {
            try device.lockForConfiguration()
            device.videoZoomFactor = zoom
            device.unlockForConfiguration()
            zoomFactor = zoom
        } catch {
            print("Zoom error: \(error)")
        }
    }

    // Keep zoom between 1x and the lower of maxZoom and the device limit
    static func clampedZoom(_ factor: CGFloat, deviceMax: CGFloat) -> CGFloat {
        min(max(factor, 1), min(maxZoom, deviceMax))
    }

    // Flash button cycles off → auto → on
    static func nextFlashMode(after mode: AVCaptureDevice.FlashMode) -> AVCaptureDevice.FlashMode {
        switch mode {
        case .off: return .auto
        case .auto: return .on
        default: return .off
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
