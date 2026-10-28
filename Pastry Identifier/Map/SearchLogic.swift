//
//  SearchLogic.swift
//  Pastry Identifier
//
//  Created by Vic  on 10/13/26.
//
import MapKit

// Finds bakeries near a point (user or map center)
struct BakerySearchService {
    // How far from the center to search, in meters
    static let searchRadius: CLLocationDistance = 2500
    private var searchRadius: CLLocationDistance { Self.searchRadius }

    // Two passes: pastry matches, then all nearby bakeries. Nearest first
    func search(for pastryName: String?, near center: CLLocation) async -> [Bakery] {
        let bakeriesAndCafes = MKPointOfInterestFilter(including: [.bakery, .cafe])

        // Pass 1: places matching the pastry name
        let pastryRequest = MKLocalSearch.Request()
        pastryRequest.naturalLanguageQuery = pastryName ?? "bakery"
        pastryRequest.resultTypes = .pointOfInterest
        pastryRequest.pointOfInterestFilter = bakeriesAndCafes
        pastryRequest.region = MKCoordinateRegion(
            center: center.coordinate,
            latitudinalMeters: searchRadius * 2,
            longitudinalMeters: searchRadius * 2
        )

        // Pass 2: all bakeries and cafes nearby
        let nearbyRequest = MKLocalPointsOfInterestRequest(center: center.coordinate, radius: searchRadius)
        nearbyRequest.pointOfInterestFilter = bakeriesAndCafes

        // Run both searches in parallel
        async let pastryResponse = MKLocalSearch(request: pastryRequest).start()
        async let nearbyResponse = MKLocalSearch(request: nearbyRequest).start()
        // A failed search adds no places
        let pastryPlaces = (try? await pastryResponse)?.mapItems ?? []
        let nearbyPlaces = (try? await nearbyResponse)?.mapItems ?? []

        // No pastry: pass 1 only adds places, nothing is a likely match
        return merge(pastryPlaces: pastryPlaces, nearbyPlaces: nearbyPlaces, center: center, markMatches: pastryName != nil)
    }

    // Merge both passes, skipping duplicates; split out so it can be unit tested
    func merge(pastryPlaces: [MKMapItem], nearbyPlaces: [MKMapItem], center: CLLocation, markMatches: Bool = true) -> [Bakery] {
        var results = pastryPlaces.map { Bakery(mapItem: $0, hasPastry: markMatches) }
        for place in nearbyPlaces where !results.contains(where: { isSamePlace($0.mapItem, place) }) {
            results.append(Bakery(mapItem: place, hasPastry: false))
        }

        // Region is only a hint: drop far places, sort nearest first
        return results
            .filter { distance(to: $0, from: center) <= searchRadius }
            .sorted { distance(to: $0, from: center) < distance(to: $1, from: center) }
    }

    // Match the same place across searches by Apple Maps ID
    private func isSamePlace(_ a: MKMapItem, _ b: MKMapItem) -> Bool {
        if let idA = a.identifier, let idB = b.identifier {
            return idA == idB
        }
        return a.name == b.name
    }

    private func distance(to bakery: Bakery, from center: CLLocation) -> CLLocationDistance {
        bakery.mapItem.location.distance(from: center)
    }
}
