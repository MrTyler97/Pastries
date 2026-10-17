//
//  SearchLogic.swift
//  Pastry Identifier
//
//  Created by Vic  on 10/13/26.
//
import MapKit

// Finds bakeries near the user. Takes inputs and returns results, so it knows nothing about the view
struct BakerySearchService {
    // How far from the user to search, in meters
    let searchRadius: CLLocationDistance = 10000

    // Search in two passes and merge the results:
    //   1. Bakeries and cafes that match the pastry name ("Croissant")
    //   2. Every bakery and cafe nearby, as a fallback
    // Returns the merged list, nearest first.
    func search(for pastryName: String?, near userLocation: CLLocation) async -> [Bakery] {
        let bakeriesAndCafes = MKPointOfInterestFilter(including: [.bakery, .cafe])

        // Pass 1: places matching the pastry name
        let pastryRequest = MKLocalSearch.Request()
        pastryRequest.naturalLanguageQuery = pastryName ?? "bakery"
        pastryRequest.resultTypes = .pointOfInterest
        pastryRequest.pointOfInterestFilter = bakeriesAndCafes
        pastryRequest.region = MKCoordinateRegion(
            center: userLocation.coordinate,
            latitudinalMeters: searchRadius * 2,
            longitudinalMeters: searchRadius * 2
        )

        // Pass 2: all bakeries and cafes nearby
        let nearbyRequest = MKLocalPointsOfInterestRequest(center: userLocation.coordinate, radius: searchRadius)
        nearbyRequest.pointOfInterestFilter = bakeriesAndCafes

        // Run both searches at the same time - neither needs the other's results
        async let pastryResponse = MKLocalSearch(request: pastryRequest).start()
        async let nearbyResponse = MKLocalSearch(request: nearbyRequest).start()
        // A failed search just contributes no places
        let pastryPlaces = (try? await pastryResponse)?.mapItems ?? []
        let nearbyPlaces = (try? await nearbyResponse)?.mapItems ?? []

        // Merge: pastry matches first, then nearby places that aren't already in the list
        var results = pastryPlaces.map { Bakery(mapItem: $0, hasPastry: true) }
        for place in nearbyPlaces where !results.contains(where: { isSamePlace($0.mapItem, place) }) {
            results.append(Bakery(mapItem: place, hasPastry: false))
        }

        // The search region is only a hint, so drop anything too far away, then sort nearest first
        return results
            .filter { distance(to: $0, from: userLocation) <= searchRadius }
            .sorted { distance(to: $0, from: userLocation) < distance(to: $1, from: userLocation) }
    }

    // The two searches return separate objects for the same place, so compare by Apple Maps ID
    private func isSamePlace(_ a: MKMapItem, _ b: MKMapItem) -> Bool {
        if let idA = a.identifier, let idB = b.identifier {
            return idA == idB
        }
        return a.name == b.name
    }

    private func distance(to bakery: Bakery, from userLocation: CLLocation) -> CLLocationDistance {
        bakery.mapItem.location.distance(from: userLocation)
    }
}
