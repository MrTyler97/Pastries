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
    
    var body: some View{
        VStack(){
            if pastry != nil{
                Spacer()
                HStack{
                    // Maps component
                    Button(action: {
                      // Add code
                    }){
                        HStack{
                            Text("Find")
                            Image(systemName: "location.fill")
                        }
                        .padding()
                        .font(.subheadline)
                        .foregroundStyle(.primary)
                        .background(.ultraThinMaterial)
                        .cornerRadius(20)
                        .frame(maxWidth: 350)
                    }
                    //Allergen information
                    Button(action: {
                        allergensAlert.toggle()
                    }){
                        HStack{
                            Text("Allergens")
                            Image(systemName: "exclamationmark.bubble.fill")
                        }
                        .padding()
                        .font(.subheadline)
                        .foregroundStyle(.red)
                        .background(.ultraThinMaterial)
                        .cornerRadius(20)
                        .frame(maxWidth: 350)
                    }
                    .alert("May Contain", isPresented: $allergensAlert){
                        Button("OK"){
                            
                        }
                    } message: {
                            Text("1,2,3")
                    }
                    // Nutrition component for item (api call)
                    Button(action: {
                      // Add code
                    }){
                        HStack{
                            Text("Nutrition")
                            Image(systemName: "list.bullet.rectangle.portrait")
                        }
                        .padding()
                        .font(.subheadline)
                        .foregroundStyle(.brown)
                        .background(.ultraThinMaterial)
                        .cornerRadius(20)
                        .frame(maxWidth: 350)
                    }
                }
                Spacer()
                Spacer()
                // Place holder for asset image of item
                Image("\(imageName)")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .cornerRadius(30)
                    .shadow(radius: 15)
                    .padding()
                // Heading for name of item (pullled from assets)
                Button(action: {
                    classificationDisclaimer.toggle()
                }){
                    HStack{
                        Text(imageName)
                            .font(.headline)
                            .foregroundStyle(.brown)
                        Image(systemName: "info.circle.fill")
                            .foregroundStyle(.brown)
                    }
                }
                .alert("Disclaimer",isPresented: $classificationDisclaimer){
                    Button("I Understand"){}
                } message: {
                    Text("This model may produce inaccurate results. Please verify findings independently and use with appropriate caution.")
                }
                //Confidence text
                Text(note)
                    .font(.system(size: 10.0))
                    .foregroundStyle(.secondary)
                Spacer()
            } else {
                Spacer()
                Image(systemName: "xmark")
                    .foregroundStyle(.secondary)
                    .padding()
                    .frame(width: 200, height: 200)
                    .background(.ultraThinMaterial)
                    .cornerRadius(30)
                    .padding()
                Button(action: {
                    classificationDisclaimer.toggle()
                }){
                    HStack{
                        Text(imageName)
                            .font(.headline)
                            .foregroundStyle(.black)
                        Image(systemName: "info.circle.fill")
                            .foregroundStyle(.brown)
                    }
                }
                .alert("Disclaimer",isPresented: $classificationDisclaimer){
                    Button("I Understand"){}
                } message: {
                    Text("This model may produce inaccurate results. Please verify findings independently and use with appropriate caution.")
                }
                //Confidence text
                Text(note)
                    .font(.system(size: 10.0))
                    .foregroundStyle(.secondary)
                Spacer()
            }
            // Information and history of item (pulled from assets
            if let pastry = pastry{ //unwrap 
                Text("\(pastry.origin)")
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(20)
                    .frame(maxWidth: 350)
                Text("Origin")
                    .font(.system(size: 10.0))
                    .foregroundStyle(.secondary)
            Spacer()
                Text("\(pastry.description)")
                        .padding()
                        .multilineTextAlignment(.center)
                        .background(.ultraThinMaterial)
                        .cornerRadius(30)
                        .frame(width: 350)
                Text("Description")
                    .font(.system(size: 10.0))
                    .foregroundStyle(.secondary)
                Spacer()
            }
            }
        }
    }


