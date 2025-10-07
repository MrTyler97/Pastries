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

// Strict typing 
struct Pastry {
    var name: String
    var origin: String
    var description: String
}
// Create pastry data
var pastries: [Pastry] = [
    Pastry(name: "Croissant", origin: "France", description: "A buttery flaky bread named for its distinctive crescent shape. Croissants are made of a leavened variant of puff pastry. The yeast dough is layered with butter, rolled and folded several times in succession, then rolled into a sheet, a technique called laminating. Croissants have long been a staple of French bakeries and pâtisseries."),
    Pastry(name: "Cookie", origin: "Persia (Iran)", description: " A cookie is a small sweet, crispy or cake-like pastry most often made with flour, sugar, liquid and fat. Persia were one of the first countries where sugar cane was grown and harvested. Cakes and pastries were a well-known treat within the Persian Empire."),
    Pastry(name: "Kouign Amann", origin: "France (Brittany)", description: "A Breton cake containing layers of butter and sugar folded in, similar in fashion to puff pastry albeit with fewer layers. The sugar caramelizes during baking. The name derives from the Breton words for cake ('kouign') and butter ('amann')."),
    Pastry(name: "Danish", origin: "Denmark", description: "A sweet pastry, of Viennese origin, which has become a speciality of Denmark and neighboring Scandinavian countries. Called 'facturas' in Argentina and neighbouring countries"),
    Pastry(name: "Scone", origin: "Scotland", description: "Traditionally they are made with flour, butter, sugar and milk. Scones are thought to have originated in Scotland in the early 1500s and the first known print reference was made by a Scottish poet in 1513. "),
]
// Get Patry information
func getPastry(name: String) -> Pastry? {
    return pastries.first { $0.name.lowercased() == name.lowercased() }
}
// Main View
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
            let model = try Pastry_SelectorV5_1(configuration: config)
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
                    if topResult.identifier == "Other"{
                        self.imageName = "Not Applicable"
                        self.note = "This image does not fall within the classification types"
                    }
                    else if topResult.confidence > 0.90{
                        self.imageName = topResult.identifier
                        self.note = "High Confidence"
                    }
                    else if topResult.confidence > 0.60 && topResult.confidence < 0.90{
                        self.imageName = topResult.identifier
                        self.note = "Low Confidence, item may be misclassified"
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
    // Main
    var body: some View {
        VStack {
            Spacer()
            // Diplay Image
            if let selectedImage = selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
                    .cornerRadius(30)
                    .shadow(radius: 15)
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
                    classifyImage(PastryImage: selectedImage)
                    showingSheet.toggle()
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
                            // Call sheet with information prefilled
                            SheetComponent(imageName: imageName, note: note, pastry: getPastry(name: imageName))
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
