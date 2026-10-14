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
    // Tapped marker. Also drives the sheet: closing the sheet sets this back to nil
    @State var selected: Bakery? = nil

    // Ask the search service for bakeries around the user (see SearchLogic.swift)
    func search() async {
        guard let userLocation = locationManager.location else { return }
        bakeries = await BakerySearchService().search(for: pastry?.name, near: userLocation)
    }

    var body: some View {
        NavigationStack{
            Map(position: $position, selection: $selected){
                // Display user location
                UserAnnotation()

                // Display searched locations. Brown = matched the pastry, gray = just a nearby bakery/cafe
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
            // Runs on appear, and again whenever the location changes (e.g. the first fix arrives)
            .task(id: locationManager.location) {
                await search()
            }
            // Explain an empty map when location is off
            .overlay(alignment: .bottom) {
                if locationManager.isDenied {
                    Text("Turn on location in Settings to find bakeries near you.")
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
