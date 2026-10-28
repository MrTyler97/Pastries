//
//  AppConfig.swift
//  Pastry Identifier
//

import Foundation

enum AppConfig {
    static var proxyAPIKey: String {
        // Grab API key from app resources
        let key = Bundle.main.object(forInfoDictionaryKey: "ProxyAPIKey") as? String ?? ""
        if key.isEmpty { assertionFailure("ProxyAPIKey missing - check Config/secrets.xcconfig") }
        return key
    }
}
