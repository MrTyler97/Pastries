//
//  NutritionService.swift
//  Pastry Identifier
//
//  Fetches nutrition data for a classified pastry from the Pastries proxy.
//

import Foundation

// One case per proxy status
enum NutritionError: Error {
    case unauthorized                           // 401 - bad/missing key
    case notFound                               // 404 - unknown food_id
    case rateLimited(retryAfter: TimeInterval?) // 429 - too many requests this minute
    case quotaExhausted                         // 503 - daily quota spent
    case upstream                               // 502 and other failures
    case decoding(Error)                        // JSON didn't match PastryFood

    // Message shown in the nutrition popover
    var message: String {
        switch self {
        case .notFound: return "No nutrition data for this pastry"
        case .rateLimited: return "Too many requests, try again shortly"
        case .quotaExhausted: return "Nutrition data unavailable today, try again tomorrow"
        case .unauthorized, .upstream, .decoding: return "Couldn't load nutrition data"
        }
    }
}

struct NutritionService {
    // Deployed proxy on Fly.io
    let baseURL = URL(string: "https://proxy-restless-flower-6045.fly.dev/")!

    // Classifier label -> FatSecret food_id
    let foodIds: [String: String] = [
        "croissant": "3533",
        "cookie": "3936",
        "scone": "3722",
        "kouign amann": "132729244",
        "danish": "4212",
    ]

    func food(forClassLabel label: String) async throws -> PastryFood {
        // Build the URL: /nutrition/:foodId
        guard let foodId = foodIds[label.lowercased()] else { throw NutritionError.notFound }
        let url = baseURL.appending(path: "nutrition/\(foodId)")

        var request = URLRequest(url: url)
        request.setValue("Bearer \(AppConfig.proxyAPIKey)", forHTTPHeaderField: "Authorization")

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let http = response as? HTTPURLResponse else { throw NutritionError.upstream }

        // Check status first; error bodies don't decode as PastryFood
        switch http.statusCode {
        case 200:
            break
        case 401:
            throw NutritionError.unauthorized
        case 404:
            throw NutritionError.notFound
        case 429:
            let retryAfter = http.value(forHTTPHeaderField: "Retry-After").flatMap { TimeInterval($0) }
            throw NutritionError.rateLimited(retryAfter: retryAfter)
        case 503:
            throw NutritionError.quotaExhausted
        default:
            throw NutritionError.upstream
        }

        do {
            return try JSONDecoder().decode(PastryFood.self, from: data)
        } catch {
            throw NutritionError.decoding(error)
        }
    }
}
