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

    // Identify acts as a button: open the camera and stay on the current tab
    var tabSelection: Binding<AppTab> {
        Binding(
            get: { selectedTab },
            set: { tab in
                if tab == .identify {
                    identify.showingCamera = true
                } else {
                    selectedTab = tab
                }
            }
        )
    }

    var body: some View {
        TabView(selection: tabSelection) {
            Tab("Home", systemImage: "house.fill", value: .home) {
                HomeView(selectedTab: $selectedTab)
            }
            Tab("Identify", systemImage: "camera.viewfinder", value: .identify) {
                // Never shown; the tab opens the camera instead
                Color.clear
            }
            Tab("Bakeries", systemImage: "map", value: .bakeries) {
                MapView(pastry: nil, showsClose: false)
            }
        }
        .environment(identify)
        // Camera lives here so any tab can open it
        .fullScreenCover(isPresented: $identify.showingCamera) {
            CameraView(image: $identify.selectedImage, pickedItem: $identify.selectedItem)
        }
        // Load a photo picked from the camera's Library button
        .onChange(of: identify.selectedItem) { _, newItem in
            Task { await identify.load(newItem) }
        }
        // Identify as soon as a photo is ready
        .onChange(of: identify.selectedImage) { _, newImage in
            if newImage != nil {
                identify.identify()
            }
        }
        // Result opens over whichever tab is showing
        .sheet(isPresented: $identify.showingResult) {
            SheetComponent(imageName: identify.imageName, note: identify.note, pastry: getPastry(name: identify.imageName), capturedImage: identify.selectedImage)
                // Solid background so the photo header fades cleanly
                .presentationBackground(Color(.systemBackground))
            // Allows sheet to load halfway intially with the option to enlarge
                .presentationDetents(
                    (identify.imageName == "Not Applicable" || identify.imageName == "Unclassified") ? [.height(300)] : [.medium, .large]
                )
                .presentationDragIndicator(identify.imageName == "Not Applicable" || identify.imageName == "Unclassified" ? .hidden : .visible)
        }
    }
}

#Preview {
    RootTabView()
}
