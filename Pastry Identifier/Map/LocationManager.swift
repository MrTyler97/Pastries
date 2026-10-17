//
//  LocationManager.swift
//  Pastry Identifier
//
//  Asks for location permission and gets the user's current location.
//

import CoreLocation

@Observable
class LocationManager: NSObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()

    // The user's current location (nil until the first fix arrives)
    var location: CLLocation?
    // True when the user has turned location off for this app
    var isDenied = false
    // True while waiting for a location fix
    var isLocating = false

    override init() {
        super.init()
        // ~100 m is plenty for finding bakeries and arrives much faster than the default (best) accuracy
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        // Setting the delegate makes iOS call locationManagerDidChangeAuthorization right away
        manager.delegate = self
    }

    // Called on startup and whenever the user changes the permission
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            isDenied = false
            // Use a location from the last 5 minutes right away if iOS has one, otherwise ask for a new fix
            if let recent = manager.location, recent.timestamp.timeIntervalSinceNow > -300 {
                location = recent
            } else {
                isLocating = true
                manager.requestLocation() // One-time fix, delivered to didUpdateLocations
            }
        case .denied, .restricted:
            isDenied = true
        @unknown default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.last
        isLocating = false
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error)")
        isLocating = false
    }
}
