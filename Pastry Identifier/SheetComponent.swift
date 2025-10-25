//
//  SheetComponent.swift
//  Pastry Identifier
//
//  Created by Vic  on 10/6/25.
//

import SwiftUI

// Sheet component view
struct SheetComponent: View {
    let imageName: String
    let note: String
    let pastry: Pastry?
    
    @State private var classificationDisclaimer = false
    @State private var allergensAlert = false
    @State private var popOverShowing = false
    @State private var showMap = false
    @State private var showNutrition = false
    
    var body: some View{
        VStack(){
            if pastry != nil{
                Spacer()
                // Components for more information
                HStack{
                    // Maps component
                    Button(action: {
                        // Add code
                        showMap.toggle()
                    }){
                        HStack{
                            Image(systemName: "location.magnifyingglass")
                        }
                        .padding()
                        .font(.subheadline)
                        .foregroundStyle(.primary)
                        .glassEffect(.regular.interactive())
                        .frame(maxWidth: 350)
                    }
                    .fullScreenCover(isPresented: $showMap){
                        MapView()
                    }
                    //Allergen information
                    Button(action: {
                        popOverShowing.toggle()
                    }){
                        HStack{
                            Image(systemName: "exclamationmark.bubble.fill")
                        }
                        .padding()
                        .font(.subheadline)
                        .foregroundStyle(.red)
                        .glassEffect(.regular.interactive())
                        .frame(maxWidth: 350)
                    }
                    // Small Pop up component
                    .popover(isPresented: $popOverShowing ){
                        VStack{
                            Text("May Contain")
                                .font(.headline)
                            HStack{
                                Text("Dairy")
                                Text("Gluten")
                                Text("Nuts")
                                Text("Yeast")
                            }
                            .padding()
                        }
                        .padding()
                        .presentationCompactAdaptation(.popover)
                    }
                    // Nutrition component for item (api call)
                    Button(action: {
                        // Add code
                        showNutrition.toggle()
                    }){
                        HStack{
                            Image(systemName: "list.bullet.rectangle")
                        }
                        .padding()
                        .font(.subheadline)
                        .foregroundStyle(.green)
                        .glassEffect(.regular.interactive())
                        .frame(maxWidth: 350)
                    }
                    .popover(isPresented: $showNutrition){
                            NutritionRowView()
                            .presentationCompactAdaptation(.popover)
                            .padding()
                    }
                }
                Spacer()
                Spacer()
                // Place holder for asset image of item
                ZStack(alignment: .topTrailing) {
                    Image("\(imageName)")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .cornerRadius(30)
                        .shadow(radius: 15)
                        .padding()
                    
                    Button(action: {
                        classificationDisclaimer.toggle()
                    }) {
                        Image(systemName: "info.circle.fill")
                            .font(.title2)
                            .padding(8)
                            .foregroundStyle(.bar)
                    }
                    .padding()
                    .alert("Disclaimer", isPresented: $classificationDisclaimer) {
                        Button("I Understand") {}
                    } message: {
                        Text("This model may produce inaccurate results. Please verify findings independently and use with appropriate caution.")
                    }
                }
                // Heading for name of item (pullled from assets)
                HStack{
                    Text(imageName)
                        .font(.headline)
                }
                //Confidence text
                Text(note)
                    .font(.system(size: 10.0))
                Spacer()
            } else {
                Spacer()
                HStack{
                    Text(imageName)
                        .font(.headline)
                    Button(action: {
                        classificationDisclaimer.toggle()
                    }){
                            Image(systemName: "info.circle.fill")
                    }
                    .alert("Disclaimer",isPresented: $classificationDisclaimer){
                        Button("I Understand"){}
                    } message: {
                        Text("This model may produce inaccurate results. Please verify findings independently and use with appropriate caution.")
                    }
                }
                //Confidence text
                Text(note)
                    .font(.system(size: 10.0))
                Spacer()
            }
            // Information and history of item (pulled from assets
            if let pastry = pastry{ //unwrap
                Text("\(pastry.origin)")
                    .padding()
                    //.glassEffect(.regular.interactive(), in: .rect(cornerRadius: 16))
                    .background(.ultraThinMaterial)
                    .cornerRadius(16)
                Text("Origin")
                    .font(.system(size: 10.0))
                Spacer()
                Text("\(pastry.description)")
                    .padding()
                    .multilineTextAlignment(.center)
                    //.glassEffect(.regular.interactive(), in: .rect(cornerRadius: 16))
                    .background(.ultraThinMaterial)
                    .cornerRadius(16)
                    .frame(maxWidth: 350)
                Text("Description")
                    .font(.system(size: 10.0))
                Spacer()
            }
        }
    }
}


