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
    // Matched the pastry search
    var hasPastry = false
    // Nil for a generic bakery search
    var pastryName: String? = nil

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
                    
                    // Likely match vs. unconfirmed nearby bakery
                    if let pastryName {
                        if hasPastry {
                            Label("Likely has \(pastryName)", systemImage: "checkmark.seal.fill")
                                .font(.caption)
                                .foregroundStyle(.brown)
                        } else {
                            Label("Nearby bakery: \(pastryName) not confirmed, call ahead", systemImage: "questionmark.circle")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }

                    // Tap to call
                    if let phone = location.phoneNumber {
                        let digits = phone.filter { $0.isNumber || $0 == "+" }
                        if let url = URL(string: "tel:\(digits)") {
                            Link(destination: url) {
                                Label(phone, systemImage: "phone")
                            }
                            .font(.caption)
                        } else {
                            Label(phone, systemImage: "phone")
                                .font(.caption)
                        }
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
