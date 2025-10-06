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
    
    var body: some View{
        VStack(){
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
                .font(.system(size: 8.0))
                //.baselineOffset(6.0)
            // Information and history of item (pulled from assets
            Text("Information")
                .padding()
            // Nutrition component for item. (api call)
            Text("Placeholder for nutrition component")
        }
    }
    
}
