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
// Add allergens to object
var pastries: [Pastry] = [
    Pastry(name: "Croissant", origin: "France", description: "A buttery flaky bread named for its distinctive crescent shape. Croissants are made of a leavened variant of puff pastry. The yeast dough is layered with butter, rolled and folded several times in succession, then rolled into a sheet, a technique called laminating. Croissants have long been a staple of French bakeries and pâtisseries."),
    Pastry(name: "Cookie", origin: "Persia", description: "A small sweet, crispy or cake like pastry most often made with flour, sugar, liquid and fat. Persia was among the first regions to cultivate sugar cane, making cakes and pastries a well known delicacy within the Persian Empire (Modern-day Iran)."),
    Pastry(name: "Kouign Amann", origin: "France", description: "A Breton cake containing layers of butter and sugar folded in, similar in fashion to puff pastry albeit with fewer layers. The sugar caramelizes during baking. The name derives from the Breton words for cake ('kouign') and butter ('amann')."),
    Pastry(name: "Danish", origin: "Denmark", description: "A sweet pastry, of Viennese origin, which has become a speciality of Denmark and neighboring Scandinavian countries. Called 'facturas' in Argentina and neighbouring countries"),
    Pastry(name: "Scone", origin: "Scotland", description: "A lightly sweetened baked good traditionally made with flour, butter, sugar and milk. Scones are thought to have originated in Scotland in the early 1500s, with the first known print reference made by a Scottish poet in 1513."),
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
    // Main Sheet viewability
    @State private var showingSheet = false
    // Info Sheet
    @State private var infoShowing = false
    // Classification Name
    @State private var imageName = ""
    // Classification note
    @State private var note = ""
    
    // Function to classify pastry
    func classifyImage(PastryImage:UIImage? ) {
        
        // Convert image to ciImage for Vision framework compatability
        guard let image = PastryImage else { return }
        guard let ciImage = CIImage(image: image) else {
            print("Failed to create CIImage")
            return }
        
        do{
            let config = MLModelConfiguration()
            // Initialize model
            let model = try Pastry_SelectorV6(configuration: config)
            // Initialize vision model
            let visionModel = try VNCoreMLModel(for: model.model)
            // Create a request and run model within
            let request = VNCoreMLRequest(model: visionModel) { request, error in
                if let error = error {
                    print("Error: \(error)")
                    return
                }
                // Get results
                guard let results = request.results as? [VNClassificationObservation], let topResult = results.first else { print("No results");return }
                // Parse through results
                DispatchQueue.main.async{
                    // Logic for classification displayed
                    if topResult.identifier == "Other"{
                        self.imageName = "Not Applicable"
                        self.note = "Image not within classification scope"
                    }
                    else if topResult.confidence > 0.90{
                        self.imageName = topResult.identifier
                        self.note = "High Confidence"
                    }
                    else if topResult.confidence > 0.55 && topResult.confidence < 0.90{
                        self.imageName = topResult.identifier
                        self.note = "Low Confidence - may be misclassified"
                    }
                    else {
                        self.imageName = "Unclassified"
                        self.note = "Very Low Confidence - try different angle"
                    }
                }
            }
            //
            let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])
            // Run the model
            try handler.perform([request])
        } catch {
            //
            print("Error")
        }
    }
    // Main
    var body: some View {
        NavigationStack{
            ZStack{
                VStack {
                    Spacer()
                    // Title
                    Text("Pastries")
                        .font(.largeTitle)
                        .bold()
                        .padding()
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
                            .glassEffect(.clear, in: .rect(cornerRadius: 16))
                    }
                    Spacer()
                    // Selector for classification
                    if let selectedImage = selectedImage {
                        Button(action: {
                            classifyImage(PastryImage: selectedImage)
                            showingSheet.toggle()
                        }){
                            Text("Identify")
                                .font(.headline)
                                .foregroundStyle(Color(.white))
                                .padding()
                                .frame(width: 300)
                                .glassEffect(.regular.tint(.green.opacity(0.7)).interactive())
                        
                        }
                        .sheet(isPresented: $showingSheet){
                            // Call sheet with information prefilled
                            SheetComponent(imageName: imageName, note: note, pastry: getPastry(name: imageName))
                            // Allows sheet to load halfway intially with the option to enlarge
                                .presentationDetents(
                                    (imageName == "Not Applicable" || imageName == "Unclassified") ? [.height(300)] : [.height(650), .large]
                                )
                                .presentationDragIndicator(.hidden)
                        }
                    }
                    Spacer()
                        Button(action: {
                            showingCamera.toggle()
                        }){
                            Image(systemName: "camera")
                                .foregroundStyle(.white)
                                .padding()
                                .frame(width: 300)
                                .glassEffect(.clear.interactive())
                        }
                        // A sheet in SwiftUI is a view that pops up over your current interface to present additional content or functionality. In this case the camera screen.
                        .sheet(isPresented: $showingCamera){
                            CameraView(image: $selectedImage)
                        }
                        PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()){
                            Image(systemName: "photo")
                                .foregroundStyle(.white)
                                .padding()
                                .frame(width: 300)
                                .glassEffect(.clear.interactive())
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
                    .padding()
                    Spacer()
                }
                .padding()
                // Information section
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: {
                            infoShowing.toggle()
                        }){
                            Image(systemName: "info")
                        }
                        .sheet(isPresented: $infoShowing, ) {
                            VStack {
                                Spacer()
                                Text("Welcome to Pastries")
                                    .font(.largeTitle)
                                    .bold()
                                    .padding()
                                Spacer()
                                Text("Model can only detect 5 different pastries.")
                                    .padding()
                                    .multilineTextAlignment(.center)
                                    .frame(width: 300)
                                    .background(.regularMaterial)
                                    .cornerRadius(16)
                                Text("More coming soon")
                                    .font(.caption)
                                    .padding(.bottom)
                                VStack(alignment: .center) {
                                    ForEach (pastries, id: \.name){ pastry in
                                        Text("\(pastry.name)")
                                            .bold()
                                            .padding(2)
                                    }
                                }
                                .padding()
                                .multilineTextAlignment(.center)
                                .frame(width: 300)
                                .background(.regularMaterial)
                                .cornerRadius(16)
                                Spacer()
                            }
                            .presentationDetents([.medium])
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.brown.gradient)
            .ignoresSafeArea()
        }
    }
}


#Preview {
    ContentView()
}
