//
//  ContentView.swift
//  Pastry Identifier
//
//  Created by Vic  on 9/19/25.
//

import SwiftUI
import CoreML
import PhotosUI

struct ContentView: View {
    // holds selected photo Item
    @State private var selectedItem: PhotosPickerItem?
    // Hold loaded image
    @State private var selectedImage: UIImage?
    // Camera sheet visability
    @State private var showingCamera = false
    
    func classifyImage() {
        
        // Initialize model
//        let model = try PastryIdentifier(configuration: MLModelConfiguration())
    }
    
    var body: some View {
        VStack {
            Spacer()
            // Diplay Image
            if let selectedImage = selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
                    .cornerRadius(30)
                    .padding()
            } else {
                // Place holder area if no image
                Text("No image selected")
                    .foregroundStyle(.secondary)
                    .padding()
                    .frame(width: 300, height: 300)
                    .background(.ultraThinMaterial)
                    .cornerRadius(30)
            }
            Spacer()
            // Selector for classification
            if let selectedImage = selectedImage {
                    Text("Identify Pastry")
                        .font(.headline)
                        .foregroundStyle(Color(.white))
                        .padding()
                        .frame(width: 300)
                        .background(Color.green.gradient)
                        .cornerRadius(30)
            }
            Button(action: {
                showingCamera.toggle()
            }){
                Text("Open Camera")
                    .font(.headline)
                    .foregroundStyle(Color(.brown))
                    .padding()
                    .frame(width: 300)
                    .background(Color.brown.opacity(0.1))
                    .cornerRadius(30)
            }
            // A sheet in SwiftUI is a view that pops up over your current interface to present additional content or functionality. In this case the camera screen.
            .sheet(isPresented: $showingCamera){
                CameraView(image: $selectedImage)
            }
            .padding()
            PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()){
                Text("Select Image")
                    .font(.headline)
                    .foregroundStyle(Color(.white).opacity(0.8))
                    .padding()
                    .frame(width: 300)
                    .background(Color.brown)
                    .cornerRadius(30)
            }
            .onChange(of: selectedItem) { olditem, newitem in
                if let newitem = newitem {
                    // Task just makes what ever code inside run aynchronusly
                    Task {
                        // Load raw data of image then convert it
                        if let data = try? await newitem.loadTransferable(type: Data.self), let image = UIImage(data: data) {
                            selectedImage = image // Update elected image
                        }
                    }
                }
            }
            Spacer()
        }
        .padding()
    }
}


#Preview {
    ContentView()
}
