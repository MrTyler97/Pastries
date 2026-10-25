//
//  IdentifyView.swift
//  Pastry Identifier
//
//  Created by Vic  on 9/19/25.
//

import SwiftUI

// Identify tab
struct IdentifyView: View {
    @Environment(IdentifyModel.self) private var identify

    var body: some View {
        @Bindable var identify = identify
        NavigationStack{
            VStack(spacing: 20) {
                // Diplay Image
                Group {
                    if let selectedImage = identify.selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFit()
                            .clipShape(.rect(cornerRadius: 30))
                            .shadow(radius: 15)
                    } else {
                        // Place holder area if no image
                        ContentUnavailableView(
                            "Add a photo",
                            systemImage: "photo.badge.plus",
                            description: Text("Take a photo or choose one from your library to identify a pastry.")
                        )
                        .background(Color(.secondarySystemBackground), in: .rect(cornerRadius: 30))
                    }
                }
                .frame(maxHeight: .infinity)

                // Selector for classification
                if identify.selectedImage != nil {
                    Button(action: {
                        identify.identify()
                    }){
                        Label("Identify", systemImage: "sparkle.magnifyingglass")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.pastryGradient, in: .capsule)
                    }
                }
                HStack {
                    Button(action: {
                        identify.showingCamera = true
                    }){
                        Label("Camera", systemImage: "camera")
                            .frame(maxWidth: .infinity)
                    }
                    Button(action: {
                        identify.showingPicker = true
                    }){
                        Label("Library", systemImage: "photo")
                            .frame(maxWidth: .infinity)
                    }
                }
                .buttonStyle(.glass)
                .controlSize(.large)
            }
            .padding()
            .navigationTitle("Identify")
            .sheet(isPresented: $identify.showingResult){
                // Call sheet with information prefilled
                SheetComponent(imageName: identify.imageName, note: identify.note, pastry: getPastry(name: identify.imageName))
                // Allows sheet to load halfway intially with the option to enlarge
                    .presentationDetents(
                        (identify.imageName == "Not Applicable" || identify.imageName == "Unclassified") ? [.height(300)] : [.height(650), .large]
                    )
                    .presentationDragIndicator(.hidden)
            }
        }
    }
}

#Preview {
    IdentifyView()
        .environment(IdentifyModel())
}
