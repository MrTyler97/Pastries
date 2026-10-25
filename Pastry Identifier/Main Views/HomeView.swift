//
//  HomeView.swift
//  Pastry Identifier
//

import MapKit
import SwiftUI

// Landing page
struct HomeView: View {
    @Environment(IdentifyModel.self) private var identify
    @Binding var selectedTab: AppTab
    // Catalog pastry tapped in the carousel
    @State private var selectedPastry: Pastry?
    // Info Sheet
    @State private var infoShowing = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 28) {
                    heroCard
                    pastryCarousel
                    bakeriesCard
                }
                .padding(.vertical)
            }
            .navigationTitle("Pastries")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        infoShowing.toggle()
                    }){
                        Image(systemName: "info")
                    }
                }
            }
            .sheet(isPresented: $infoShowing) {
                PastryInfoView()
                    .presentationDetents([.medium])
            }
            // Catalog details reuse the result sheet
            .sheet(item: $selectedPastry) { pastry in
                SheetComponent(imageName: pastry.name, note: "", pastry: pastry)
                    .presentationDetents([.height(650), .large])
                    .presentationDragIndicator(.hidden)
            }
        }
    }

    // Call to action for identifying
    var heroCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: "sparkle.magnifyingglass")
                .font(.largeTitle)
            Text("What pastry is this?")
                .font(.title2)
                .bold()
            Text("Snap or choose a photo and we'll identify it.")
                .font(.subheadline)
                .opacity(0.9)
            HStack {
                Button(action: {
                    identify.showingCamera = true
                }){
                    Label("Take Photo", systemImage: "camera.fill")
                        .frame(maxWidth: .infinity)
                }
                Button(action: {
                    identify.showingPicker = true
                }){
                    Label("Choose Photo", systemImage: "photo.on.rectangle")
                        .frame(maxWidth: .infinity)
                }
            }
            .buttonStyle(.glass)
            .controlSize(.large)
            .padding(.top, 4)
        }
        .foregroundStyle(.white)
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.pastryGradient, in: .rect(cornerRadius: 28))
        .padding(.horizontal)
    }

    // Horizontal list of pastries the model knows
    var pastryCarousel: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Pastries we know")
                .font(.title3)
                .bold()
                .padding(.horizontal)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 18) {
                    ForEach(pastries) { pastry in
                        Button(action: {
                            selectedPastry = pastry
                        }){
                            VStack {
                                Image(pastry.name)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 110, height: 110)
                                    .clipShape(.circle)
                                    .overlay(Circle().stroke(.pastryGradient, lineWidth: 3))
                                Text(pastry.name)
                                    .font(.subheadline)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 4)
            }
        }
    }

    // Map preview that opens the Bakeries tab
    var bakeriesCard: some View {
        Button(action: {
            selectedTab = .bakeries
        }){
            VStack(alignment: .leading, spacing: 0) {
                Map(initialPosition: .userLocation(fallback: .automatic)) {
                    UserAnnotation()
                }
                .frame(height: 160)
                .allowsHitTesting(false)
                HStack {
                    VStack(alignment: .leading) {
                        Text("Bakeries near you")
                            .font(.headline)
                        Text("Find a bakery around you")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundStyle(.tertiary)
                }
                .padding()
            }
            .background(Color(.secondarySystemBackground))
            .clipShape(.rect(cornerRadius: 24))
        }
        .buttonStyle(.plain)
        .padding(.horizontal)
    }
}

// Information section
struct PastryInfoView: View {
    var body: some View {
        VStack {
            Spacer()
            Text("Welcome to Pastries")
                .font(.largeTitle)
                .bold()
                .padding()
            Spacer()
            Text("Model can only detect 5 different pastries.")
                .padding()
                .multilineTextAlignment(.center)
                .frame(width: 300)
                .background(.regularMaterial)
                .cornerRadius(16)
            Text("More coming soon")
                .font(.caption)
                .padding(.bottom)
            VStack(alignment: .center) {
                ForEach(pastries){ pastry in
                    Text("\(pastry.name)")
                        .bold()
                        .padding(2)
                }
            }
            .padding()
            .multilineTextAlignment(.center)
            .frame(width: 300)
            .background(.regularMaterial)
            .cornerRadius(16)
            Spacer()
        }
    }
}

#Preview {
    HomeView(selectedTab: .constant(.home))
        .environment(IdentifyModel())
}
