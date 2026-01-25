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
    // Location manager for requesting access
    let location = CLLocationManager()
    // To narrow serach
    @State private var userZipCode: String = ""
    // Users location to display
    @State var position: MapCameraPosition = .userLocation(fallback: .automatic)
    // Map Items (search results)
    @State var items: [MKMapItem] = []
    // Selected map item
    @State var selected: MKMapItem? = nil
    // Show selected location var
    @State var showSelected = false
    
    // Check system if location services are already available
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
            
        case .restricted, .denied:  // Location services currently unavailable.
            position = .automatic
            break
            
        case .notDetermined:        // Authorization not determined yet.
            manager.requestWhenInUseAuthorization()
            break
        case .authorizedAlways, .authorizedWhenInUse:   // When authorized conduct search
            search()
            
        default:
            break
        }
    }
    //Retrieving zip code
    func getZipCode(){
        CLGeocoder().reverseGeocodeLocation(location.location!) { placemarks, _ in
                    self.userZipCode = placemarks?.first?.postalCode ?? ""
                }
    }
    // Search local area for items
    func search() {
        let searchRequest = MKLocalSearch.Request()
           
           // Better query construction
           var queryComponents = ["bakery", "cafe", userZipCode]
            // add name of item to query components
           if let pastryName = pastry?.name {
               queryComponents.insert(pastryName, at: 0)
           }
           searchRequest.naturalLanguageQuery = queryComponents.joined(separator: " ")
           
           // Multiple result types if needed
           searchRequest.resultTypes = [.pointOfInterest, .address]
           
           // Add POI filter for more specific results
           searchRequest.pointOfInterestFilter = MKPointOfInterestFilter(including: [.bakery, .cafe, .restaurant])
           
           // Region setting with fallback
           if let coordinate = location.location?.coordinate {
               searchRequest.region = MKCoordinateRegion(
                   center: coordinate,
                   latitudinalMeters: 3000,  // More intuitive than degrees
                   longitudinalMeters: 3000
               )
           }
        
            MKLocalSearch(request: searchRequest).start { response, _ in
                if let response = response {
                    self.items = response.mapItems
                }
            }
        }
    
    var body: some View {
        NavigationStack{
            Map(position: $position, selection: $selected){
                // add location code - Search for nearby bakeries or cafe's that sell selected product
                
                // Display user location
                UserAnnotation()
                
                // Display searched locations
                ForEach(items, id: \.self) { place in
                    
                    Marker(place.name ?? "?", systemImage: "storefront.fill", coordinate: place.placemark.coordinate)
                    .tint(Color(.brown))
                    .tag(place)
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
            // Search call
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: {
                            search()
                        }) {
                            Image(systemName: "arrow.clockwise")
                        }
                }
            }
                
            }
            .onAppear{
                // Request user location if needed
                locationManagerDidChangeAuthorization(location)
                // Conduct search 
                search()
            }
            // All controls for map
            .mapControls(){
                MapUserLocationButton()
                MapCompass()
                MapPitchToggle()
                MapScaleView()
            }
        // Event listener for when item is selected
            .onChange(of: selected) {
                showSelected.toggle()
            }
        // Small display for selected location information
            .sheet(isPresented: $showSelected){
                if let selected = selected {
                    SelectedLocationView(location: selected)
                        .presentationDetents([.height(175)])
                }
            }
        }
    }

