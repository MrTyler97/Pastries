//
//  CameraView.swift
//  Pastry Identifier
//
//  Created by Vic  on 5/22/25.
//

import SwiftUI
import PhotosUI

struct CameraView: View {
    // Photo goes back to the parent view
    @Binding var image: UIImage?
    // Library pick goes back to the parent to load
    @Binding var pickedItem: PhotosPickerItem?
    @Environment(\.dismiss) var dismiss

    @State private var camera = CameraService()
    @State private var isCapturing = false
    // Zoom when the current pinch began; nil when not pinching
    @State private var pinchStartZoom: CGFloat?

    // Quick zoom choices
    let zoomPresets: [CGFloat] = [1, 2, 3]

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            if camera.isAvailable {
                CameraPreview(session: camera.session)
                    .ignoresSafeArea()
                    .gesture(pinchToZoom)
                frameGuide
            } else {
                unavailableMessage
            }

            controls
        }
        .task { await camera.start() }
        .onDisappear { camera.stop() }
        // Close once a library photo is picked
        .onChange(of: pickedItem) { _, newItem in
            if newItem != nil {
                dismiss()
            }
        }
    }

    // Pinch scales from the zoom the pinch started at
    var pinchToZoom: some Gesture {
        MagnifyGesture()
            .onChanged { value in
                let start = pinchStartZoom ?? camera.zoomFactor
                pinchStartZoom = start
                camera.setZoom(start * value.magnification)
            }
            .onEnded { _ in
                pinchStartZoom = nil
            }
    }

    // Helps center the pastry
    var frameGuide: some View {
        VStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 30)
                .stroke(.white.opacity(0.7), lineWidth: 2)
                .frame(width: 280, height: 280)
            Text("Center the pastry")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.8))
        }
        .allowsHitTesting(false)
    }

    var unavailableMessage: some View {
        VStack(spacing: 8) {
            Image(systemName: "camera.fill")
                .font(.largeTitle)
            Text("Camera unavailable")
                .font(.headline)
            Text("Allow camera access in Settings, or choose a photo from your library.")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundStyle(.white.opacity(0.7))
        }
        .foregroundStyle(.white)
        .padding()
    }

    // Close and flash on top; zoom, library and shutter on the bottom
    var controls: some View {
        VStack {
            HStack {
                circleButton(systemImage: "xmark") { dismiss() }
                Spacer()
                if camera.isAvailable && camera.hasFlash {
                    circleButton(systemImage: flashIcon) {
                        camera.flashMode = CameraService.nextFlashMode(after: camera.flashMode)
                    }
                }
            }
            .padding()

            Spacer()

            if camera.isAvailable {
                zoomControls
                    .padding(.bottom, 16)
            }

            HStack {
                libraryButton
                    .frame(maxWidth: .infinity)
                if camera.isAvailable {
                    shutterButton
                }
                // Balances the library button so the shutter stays centered
                Color.clear
                    .frame(maxWidth: .infinity, maxHeight: 1)
            }
            .padding(.bottom, 30)
        }
    }

    var flashIcon: String {
        switch camera.flashMode {
        case .auto: return "bolt.badge.automatic.fill"
        case .on: return "bolt.fill"
        default: return "bolt.slash.fill"
        }
    }

    // Preset chips, or the live zoom while pinching
    var zoomControls: some View {
        HStack(spacing: 8) {
            if pinchStartZoom != nil {
                Text(String(format: "%.1f×", camera.zoomFactor))
                    .font(.footnote.bold())
                    .foregroundStyle(.white)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .glassEffect(.clear, in: .capsule)
            } else {
                ForEach(zoomPresets, id: \.self) { preset in
                    let isActive = abs(camera.zoomFactor - preset) < 0.05
                    Button(action: { camera.setZoom(preset) }) {
                        Text("\(Int(preset))×")
                            .font(.footnote.bold())
                            .foregroundStyle(isActive ? Color.accentColor : .white)
                            .frame(width: 40, height: 40)
                            .glassEffect(.clear.interactive(), in: .circle)
                    }
                }
            }
        }
    }

    var libraryButton: some View {
        PhotosPicker(selection: $pickedItem, matching: .images, photoLibrary: .shared()) {
            Image(systemName: "photo.on.rectangle")
                .font(.title3)
                .foregroundStyle(.white)
                .frame(width: 52, height: 52)
                .glassEffect(.clear.interactive(), in: .circle)
        }
    }

    func circleButton(systemImage: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .font(.title3)
                .foregroundStyle(.white)
                .padding(12)
                .glassEffect(.clear.interactive(), in: .circle)
        }
    }

    var shutterButton: some View {
        Button(action: takePhoto) {
            ZStack {
                Circle()
                    .stroke(.white, lineWidth: 4)
                    .frame(width: 78, height: 78)
                Circle()
                    .fill(.white)
                    .frame(width: 64, height: 64)
            }
        }
        .disabled(isCapturing)
        .opacity(isCapturing ? 0.5 : 1)
    }

    // Take the photo, hand it back, close
    func takePhoto() {
        Task {
            isCapturing = true
            if let photo = await camera.takePhoto() {
                image = photo
                dismiss()
            }
            isCapturing = false
        }
    }
}

#Preview {
    CameraView(image: .constant(nil), pickedItem: .constant(nil))
}
