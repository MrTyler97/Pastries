//
//  Pastry_IdentifierApp.swift
//  Pastry Identifier
//
//  Created by Vic  on 9/19/25.
//

import SwiftUI

@main
struct Pastry_IdentifierApp: App {
    @State private var showSplash = true

    var body: some Scene {
        WindowGroup {
            ZStack {
                RootTabView()
                // Splash covers the app until its animation ends
                if showSplash {
                    SplashView { showSplash = false }
                }
            }
        }
    }
}
