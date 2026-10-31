//
//  SheetPhotoHeader.swift
//  Pastry Identifier
//

import SwiftUI

// Maps-style header: stock photo backdrop with the user's photo as an icon
struct SheetPhotoHeader: View {
    let imageName: String
    let capturedImage: UIImage
    let note: String

    var body: some View {
        VStack(spacing: 12) {
            backdrop
                .overlay(alignment: .bottom) {
                    icon.offset(y: 40)
                }
                // Room for the half of the icon hanging below
                .padding(.bottom, 40)

            VStack(spacing: 4) {
                Text(imageName)
                    .font(.title)
                    .bold()
                if !note.isEmpty {
                    Text(note)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            .multilineTextAlignment(.center)
            .padding(.horizontal)
        }
    }

    // Stock photo that blurs and fades into the sheet at the bottom
    private var backdrop: some View {
        // Fixed-size base so the filled photo can't stretch the fade past the clip
        Color.clear
            .frame(maxWidth: .infinity)
            .frame(height: 200)
            .background {
                Image(imageName)
                    .resizable()
                    .scaledToFill()
            }
            // Blurred copy, shown only on the bottom half
            .overlay {
                Color.clear
                    .overlay {
                        Image(imageName)
                            .resizable()
                            .scaledToFill()
                            .blur(radius: 20)
                    }
                    .clipped()
                    .mask(LinearGradient(colors: [.clear, .black], startPoint: .center, endPoint: .bottom))
            }
            // Fade uses the 300pt frame, so it finishes at the bottom edge
            .overlay {
                LinearGradient(colors: [.clear, Color(.systemBackground)], startPoint: .center, endPoint: .bottom)
            }
            .clipped()
    }

    // The photo the user took
    private var icon: some View {
        Image(uiImage: capturedImage)
            .resizable()
            .scaledToFill()
            .frame(width: 96, height: 96)
            .clipShape(.rect(cornerRadius: 22))
            .overlay(RoundedRectangle(cornerRadius: 22).stroke(.white, lineWidth: 3))
            .shadow(color: .black.opacity(0.25), radius: 8, y: 4)
    }
}

#Preview {
    if let photo = UIImage(named: "Cookie") {
        SheetPhotoHeader(imageName: "Croissant", capturedImage: photo, note: "High Confidence")
    }
}
