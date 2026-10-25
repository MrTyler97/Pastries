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
    // Hidden when shown as a tab instead of a cover
    var showsClose = true
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
    // Center of the last search
    @State private var searchCenter: CLLocation?
    // Center of the map after the user pans
    @State private var visibleCenter: CLLocation?
    // True once a search has finished
    @State private var hasSearched = false

    // Waiting on location or search
    var isLoading: Bool {
        locationManager.isLocating || isSearching
    }

    // Show once the map moves a quarter of the radius from the last search
    var showSearchAreaButton: Bool {
        guard !isSearching, let searchCenter, let visibleCenter else { return false }
        return visibleCenter.distance(from: searchCenter) > BakerySearchService.searchRadius / 4
    }

    // Load bakeries around a point
    func search(around center: CLLocation?) async {
        guard let center else { return }
        isSearching = true
        searchCenter = center
        bakeries = await BakerySearchService().search(for: pastry?.name, near: center)
        isSearching = false
        hasSearched = true

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

                // Pastry photo = likely match, gray = nearby bakery/cafe
                ForEach(bakeries) { bakery in
                    let name = bakery.mapItem.name ?? "?"
                    let coordinate = bakery.mapItem.location.coordinate
                    if bakery.hasPastry, let pastry {
                        Annotation(name, coordinate: coordinate) {
                            PastryPin(imageName: pastry.name, isSelected: selected == bakery)
                        }
                        .tag(bakery)
                    } else {
                        // Brown storefront for a generic bakery search
                        Marker(name, systemImage: "storefront.fill", coordinate: coordinate)
                            .tint(bakery.hasPastry ? .pastryBrown : Color(.gray))
                            .tag(bakery)
                    }
                }
            }
            .toolbar {
                // Navigate back to sheet view
                if showsClose {
                    ToolbarItem(placement: .topBarLeading){
                        Button(action: {
                            dismiss()
                        }){
                            Image(systemName: "chevron.backward")
                        }
                    }
                }
                // Search again around the user
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        Task { await search(around: locationManager.location) }
                    }) {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
            // Runs on appear and when the location changes
            .task(id: locationManager.location) {
                await search(around: locationManager.location)
            }
            // Track where the user has panned
            .onMapCameraChange(frequency: .onEnd) { context in
                let center = context.region.center
                visibleCenter = CLLocation(latitude: center.latitude, longitude: center.longitude)
            }
            // Search the visible area after panning
            .overlay(alignment: .top) {
                if showSearchAreaButton {
                    Button(action: {
                        Task { await search(around: visibleCenter) }
                    }) {
                        Label("Search this area", systemImage: "magnifyingglass")
                            .font(.subheadline)
                    }
                    .buttonStyle(.glass)
                    .padding(.top, 8)
                    .transition(.move(edge: .top).combined(with: .opacity))
                }
            }
            .animation(.easeInOut, value: showSearchAreaButton)
            // Status: location off, loading, or no results
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
                } else if hasSearched && bakeries.isEmpty {
                    Text("No bakeries found in this area")
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
                    hasPastry: bakery.hasPastry,
                    pastryName: pastry?.name
                )
                .presentationDetents([.height(220)])
            }
        }
    }
}


#Preview {
    MapView(pastry: Pastry(name: "Croissant", origin: "France", description: "A buttery flaky bread named for its distinctive crescent shape. Croissants are made of a leavened variant of puff pastry. The yeast dough is layered with butter, rolled and folded several times in succession, then rolled into a sheet, a technique called laminating. Croissants have long been a staple of French bakeries and pâtisseries."))
}
