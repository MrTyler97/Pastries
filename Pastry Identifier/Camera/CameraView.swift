//
//  CameraView.swift
//  Pastry Identifier
//
//  Created by Vic  on 5/22/25.
//

import SwiftUI

struct CameraView: View {
    // Photo goes back to the parent view
    @Binding var image: UIImage?
    @Environment(\.dismiss) var dismiss

    @State private var camera = CameraService()
    @State private var isCapturing = false

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            if camera.isAvailable {
                CameraPreview(session: camera.session)
                    .ignoresSafeArea()
                frameGuide
            } else {
                unavailableMessage
            }

            controls
        }
        .task { await camera.start() }
        .onDisappear { camera.stop() }
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
    }

    var unavailableMessage: some View {
        VStack(spacing: 8) {
            Image(systemName: "camera.fill")
                .font(.largeTitle)
            Text("Camera unavailable")
                .font(.headline)
            Text("Allow camera access in Settings.")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.7))
        }
        .foregroundStyle(.white)
    }

    // Close button on top, shutter on the bottom
    var controls: some View {
        VStack {
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark")
                        .font(.title3)
                        .foregroundStyle(.white)
                        .padding(12)
                        .glassEffect(.clear.interactive(), in: .circle)
                }
                Spacer()
            }
            .padding()

            Spacer()

            if camera.isAvailable {
                shutterButton
                    .padding(.bottom, 30)
            }
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
    CameraView(image: .constant(nil))
}
