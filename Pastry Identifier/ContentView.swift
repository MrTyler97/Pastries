//
//  ContentView.swift
//  Pastry Identifier
//
//  Created by Vic  on 9/19/25.
//

import SwiftUI
import CoreML
import PhotosUI
import Vision

struct ContentView: View {
    // holds selected photo Item
    @State private var selectedItem: PhotosPickerItem?
    // Hold loaded image
    @State private var selectedImage: UIImage?
    // Camera sheet visability
    @State private var showingCamera = false
    // Sheet viewability
    @State private var showingSheet = false
    // Classification Name
    @State private var imageName = ""
    // Classification note
    @State private var note = ""
    
    // Function to classify pastry
    func classifyImage(PastryImage:UIImage? ) {
        
        guard let image = PastryImage else { return }
        guard let ciImage = CIImage(image: image) else {
            print("Failed to create CIImage")
            return }
        
        do{
            let config = MLModelConfiguration()
            // Initialize model
            let model = try Pastry_SelectorV5(configuration: config)
            //
            let visionModel = try VNCoreMLModel(for: model.model)
            // Create a request
            let request = VNCoreMLRequest(model: visionModel) { request, error in
                if let error = error {
                    print("Error: \(error)")
                    return
                }
                // Get results
                guard let results = request.results as? [VNClassificationObservation], let topResult = results.first else { print("No results");return }
                //
                DispatchQueue.main.async{
                    // Logic for classification diplayed
                    if topResult.confidence > 0.80{
                        self.imageName = topResult.identifier
                        self.note = "High Confidence "
                    }
                    else if topResult.confidence > 0.60 && topResult.confidence < 0.80{
                        self.imageName = topResult.identifier
                        self.note = "Low Confidence, item may be misclassified"
                    }
                    else if topResult.identifier == "Other"{
                        self.imageName = "Not Applicable"
                        self.note = "This image does not fall within the classification types"
                    }
                    else {
                        self.imageName = "Unclassified"
                        self.note = "Very Low Confidence, try retaking the photo in a different orientation"
                    }
                }
            }
            let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])
            try handler.perform([request])
        } catch {
            //
            print("Error")
        }
    }
    
    // Sheet component view
    struct SheetCompnent: View {
        let imageName: String
        let note: String
        
        var body: some View{
            VStack{
                // Place holder for asset image of item
                Text("Placeholder")
                    .foregroundStyle(.secondary)
                    .padding()
                    .frame(width: 200, height: 200)
                    .background(.ultraThinMaterial)
                    .cornerRadius(30)
                    .padding()
                // Heading for name of item (pullled from assets)
                Text(imageName)
                    .font(.headline)
                Text(note)
                // Information and history of item (pulled from assets
                Text("Information")
                    .padding()
                // Nutrition component for item. (api call)
                Text("Placeholder for nutrition component")
            }
        }
        
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
                Button(action: {
                    showingSheet.toggle()
                    classifyImage(PastryImage: selectedImage)
                }){
                    Text("Identify Pastry")
                        .font(.headline)
                        .foregroundStyle(Color(.white))
                        .padding()
                        .frame(width: 300)
                        .background(Color.green.gradient)
                        .cornerRadius(30)
                }
                        .sheet(isPresented: $showingSheet){
                            SheetCompnent(imageName: imageName, note: note)
                            // Allows sheet to load halfway intially with the option to enlarge
                                .presentationDetents([.medium, .large])
                        }
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
