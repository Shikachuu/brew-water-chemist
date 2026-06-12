import SwiftUI
import SwiftData

struct RecipeDetailView: View {
    let recipe: Recipe
    @Query private var settingsArray: [AppSettings]
    @State private var viewModel = RecipeDetailViewModel()
    @State private var showShare = false

    private var settings: AppSettings? { settingsArray.first }
    private var quantities: [Int] { settings?.quantities ?? [500, 1000, 2000, 3000, 4500, 10000] }
    private var kit: MineralKit { settings?.mineralKit ?? .lotusRound }

    var body: some View {
        VStack(spacing: 16) {
            let (hardness, alkalinity) = calculateGHKH(recipe: recipe)
            HStack(spacing: 12) {
                SummaryCard(label: "General Hardness", value: hardness)
                    .accessibilityIdentifier("detail.gh")
                SummaryCard(label: "Alkalinity", value: alkalinity)
                    .accessibilityIdentifier("detail.kh")
            }
            .padding(.horizontal)

            VolumeSelector(quantities: quantities, selectedVolume: $viewModel.selectedVolumeMl)

            let drops = viewModel.droplets(for: recipe, kit: kit)
            VStack(spacing: 12) {
                HStack(spacing: 12) {
                    MineralCard(label: "Calcium", value: drops.calcium, unit: "drops", color: .mineralCalcium)
                    MineralCard(label: "Magnesium", value: drops.magnesium, unit: "drops", color: .mineralMagnesium)
                }
                HStack(spacing: 12) {
                    MineralCard(label: "Potassium", value: drops.potassium, unit: "drops", color: .mineralPotassium)
                    MineralCard(label: "Sodium", value: drops.sodium, unit: "drops", color: .mineralSodium)
                }
            }
            .frame(maxHeight: .infinity)
            .padding(.horizontal)
        }
        .padding(.vertical)
        .navigationTitle(recipe.name)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showShare = true
                } label: {
                    Image(systemName: "square.and.arrow.up")
                }
                .accessibilityIdentifier("detail.shareButton")
                .glassEffect(.regular.interactive(), in: Circle())
            }
        }
        .sheet(isPresented: $showShare) {
            if let url = viewModel.shareURL(for: recipe) {
                ShareRecipeSheet(recipe: recipe, shareURL: url)
            }
        }
        .onAppear {
            if let first = quantities.first {
                viewModel.selectedVolumeMl = first
            }
        }
        .keepScreenAwake()
    }
}

struct SummaryCard: View {
    let label: String
    let value: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text("\(value)")
                .font(.title)
                .fontWeight(.bold)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .glassEffect(in: RoundedRectangle(cornerRadius: 16))
    }
}
