//
//  SplashView.swift
//  Pastry Identifier
//

import SwiftUI

// Animated handoff from the static launch screen
struct SplashView: View {
    let onFinished: () -> Void

    @State private var scale: CGFloat = 1
    @State private var opacity: Double = 1

    var body: some View {
        ZStack {
            Color.accentColor
                .ignoresSafeArea()
            // Same size and position as the launch screen logo
            Image("Gradient_Icon_Map_Navigation_App_Logo-removebg-preview")
                .resizable()
                .frame(width: 250, height: 250)
                .scaleEffect(scale)
        }
        .opacity(opacity)
        .task {
            // Brief hold so the handoff isn't abrupt
            try? await Task.sleep(for: .seconds(0.25))
            withAnimation(.easeIn(duration: 0.35)) {
                scale = 1.15
                opacity = 0
            }
            try? await Task.sleep(for: .seconds(0.35))
            onFinished()
        }
    }
}

#Preview {
    SplashView(onFinished: {})
}
