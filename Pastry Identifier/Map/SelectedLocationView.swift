//
//  SelectedLocationView.swift
//  Pastry Identifier
//
//  Created by Vic  on 11/5/25.
//
import SwiftUI
import MapKit

struct SelectedLocationView: View {
    @Environment(\.dismiss) var dismiss
    let location: MKMapItem
    
    var body: some View {
        VStack(spacing: 16) {
            // Drag indicator is automatic with presentationDragIndicator
            
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(location.name ?? "Unknown")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    if let address = location.addressRepresentations?.fullAddress(includingRegion: true, singleLine: true){
                        Text(address)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    
                    if let phone = location.phoneNumber {
                        Label(phone, systemImage: "phone")
                            .font(.caption)
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal)
            
            HStack(spacing: 12) {
                Button(action: {
                    location.openInMaps()
                }) {
                    Label("Open in Maps", systemImage: "map")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.glassProminent)
            }
            .padding(.horizontal)
            
            //Spacer()
        }
        .padding(.top)

    }
}
