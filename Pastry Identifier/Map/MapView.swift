//
//  Map.swift
//  Pastry Identifier
//
//  Created by Vic  on 10/24/25.
//

import MapKit
import SwiftUI

struct MapView: View {
    // Dissmiss function
    @Environment(\.dismiss) var dismiss
    // Pastry classification used for search
    let pastry: Pastry?
    // Permission + current location
    @State private var locationManager = LocationManager()
    // Users location to display
    @State var position: MapCameraPosition = .userLocation(fallback: .automatic)
    // Search results, nearest first
    @State var bakeries: [Bakery] = []
    // Tapped marker; also drives the sheet
    @State var selected: Bakery? = nil
    // Camera fit to first results
    @State private var hasFitCamera = false
    // True while the bakery search is running
    @State private var isSearching = false

    // Waiting on location or search
    var isLoading: Bool {
        locationManager.isLocating || isSearching
    }

    // Load bakeries around the user
    func search() async {
        guard let userLocation = locationManager.location else { return }
        isSearching = true
        bakeries = await BakerySearchService().search(for: pastry?.name, near: userLocation)
        isSearching = false

        // First load only: zoom to fit all markers
        if !hasFitCamera && !bakeries.isEmpty {
            position = .automatic
            hasFitCamera = true
        }
    }

    var body: some View {
        NavigationStack{
            Map(position: $position, selection: $selected){
                // Display user location
                UserAnnotation()

                // Brown = pastry match, gray = nearby bakery/cafe
                ForEach(bakeries) { bakery in
                    Marker(bakery.mapItem.name ?? "?", systemImage: "storefront.fill", coordinate: bakery.mapItem.location.coordinate)
                        .tint(bakery.hasPastry ? Color(.brown) : Color(.gray))
                        .tag(bakery)
                }
            }
            .toolbar {
                // Navigate back to sheet view
                ToolbarItem(placement: .topBarLeading){
                    Button(action: {
                        dismiss()
                    }){
                        Image(systemName: "chevron.backward")
                    }
                }
                // Search again
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        Task { await search() }
                    }) {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
            // Runs on appear and when the location changes
            .task(id: locationManager.location) {
                await search()
            }
            // Status: location off or loading
            .overlay(alignment: .bottom) {
                if locationManager.isDenied {
                    Text("Turn on location in Settings to find bakeries near you.")
                        .font(.subheadline)
                        .padding()
                        .background(.regularMaterial)
                        .cornerRadius(16)
                        .padding()
                } else if isLoading {
                    HStack {
                        ProgressView()
                        Text("Finding bakeries…")
                    }
                    .font(.subheadline)
                    .padding()
                    .background(.regularMaterial)
                    .cornerRadius(16)
                    .padding()
                }
            }
            // All controls for map
            .mapControls(){
                MapUserLocationButton()
                MapCompass()
                MapPitchToggle()
                MapScaleView()
            }
            // Small display for selected location information
            .sheet(item: $selected){ bakery in
                SelectedLocationView(
                    location: bakery.mapItem,
                    note: bakery.hasPastry ? "May have \(pastry?.name ?? "this pastry")" : nil
                )
                .presentationDetents([.height(200)])
            }
        }
    }
}


#Preview {
    MapView(pastry: Pastry(name: "Croissant", origin: "France", description: "A buttery flaky bread named for its distinctive crescent shape. Croissants are made of a leavened variant of puff pastry. The yeast dough is layered with butter, rolled and folded several times in succession, then rolled into a sheet, a technique called laminating. Croissants have long been a staple of French bakeries and pâtisseries."))
}
