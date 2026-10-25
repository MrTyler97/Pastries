//
//  RootTabView.swift
//  Pastry Identifier
//

import SwiftUI
import PhotosUI

enum AppTab: Hashable {
    case home, identify, bakeries
}

// Root tab bar
struct RootTabView: View {
    @State private var selectedTab: AppTab = .home
    @State private var identify = IdentifyModel()

    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Home", systemImage: "house.fill", value: .home) {
                HomeView(selectedTab: $selectedTab)
            }
            Tab("Identify", systemImage: "camera.viewfinder", value: .identify) {
                IdentifyView()
            }
            Tab("Bakeries", systemImage: "map", value: .bakeries) {
                MapView(pastry: nil, showsClose: false)
            }
        }
        .environment(identify)
        // Camera and picker live here so any tab can open them
        .fullScreenCover(isPresented: $identify.showingCamera) {
            CameraView(image: $identify.selectedImage)
        }
        .photosPicker(isPresented: $identify.showingPicker, selection: $identify.selectedItem, matching: .images, photoLibrary: .shared())
        .onChange(of: identify.selectedItem) { _, newItem in
            Task { await identify.load(newItem) }
        }
        // Jump to Identify once a photo is ready
        .onChange(of: identify.selectedImage) { _, newImage in
            if newImage != nil {
                selectedTab = .identify
            }
        }
    }
}

#Preview {
    RootTabView()
}
