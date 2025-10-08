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
                        .foregroundStyle(.orange)
                        .background(.ultraThinMaterial)
                        .cornerRadius(20)
                        .frame(maxWidth: 350)
                    }
                }
            }
            Spacer()
            // Place holder for asset image of item
            Text("Placeholder")
                .foregroundStyle(.secondary)
                .frame(width: 200, height: 200)
                .background(.ultraThinMaterial)
                .cornerRadius(30)
                .padding()
            // Heading for name of item (pullled from assets)
            Text(imageName)
                .font(.headline)
            Text(note)
                .font(.system(size: 10.0))
                .foregroundStyle(.secondary)
            Spacer()
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


