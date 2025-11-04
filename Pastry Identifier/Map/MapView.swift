//
//  Map.swift
//  Pastry Identifier
//
//  Created by Vic  on 10/24/25.
//

import MapKit
import SwiftUI

struct MapView: View {
    @Environment(\.dismiss) var dismiss
    // Location manager for requesting access
    let location = CLLocationManager()
    // Users location to display
    @State var position: MapCameraPosition = .userLocation(fallback: .automatic)
    
    // Check system if location services are already available
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
            
        case .restricted, .denied:  // Location services currently unavailable.
            position = .automatic
            break
            
        case .notDetermined:        // Authorization not determined yet.
           manager.requestWhenInUseAuthorization()
            break
            
        default:
            break
        }
    }
    
    var body: some View {
        NavigationStack{
            Map(position: $position){
                // add location code - Search for nearby bakeries or cafe's that sell selected product
                
                // Display user location
                UserAnnotation()
            }
            .onAppear{
                // Request user location if needed
                locationManagerDidChangeAuthorization(location)
            }
            // All controls for map
            .mapControls(){
                MapUserLocationButton()
                MapCompass()
                MapPitchToggle()
                MapScaleView()
                // Navigate back to sheet view
            .toolbar {
                        ToolbarItem(placement: .topBarLeading){
                            Button(action: {
                                dismiss()
                            }){
                                Image(systemName: "chevron.backward")
                            }
                        }
                    }
            }
        }
    }
}

#Preview {
    MapView()
}
