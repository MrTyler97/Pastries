//
//  HomeView.swift
//  Pastry Identifier
//

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
                    IdentifyHeroCard(onTakePhoto: { identify.showingCamera = true })
                    PastryCarousel(pastries: pastries, onSelect: { selectedPastry = $0 })
                    BakeriesCard(onTap: { selectedTab = .bakeries })
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
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
            }
            // Catalog details reuse the result sheet
            .sheet(item: $selectedPastry) { pastry in
                SheetComponent(imageName: pastry.name, note: "", pastry: pastry)
                    .presentationDetents([.height(650), .large])
                    .presentationDragIndicator(.hidden)
            }
        }
    }
}

#Preview {
    HomeView(selectedTab: .constant(.home))
        .environment(IdentifyModel())
}
