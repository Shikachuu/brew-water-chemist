import SwiftUI
import SwiftData

struct RecipeListView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(AppRouter.self) private var router
    @Query(sort: \Recipe.name) private var recipes: [Recipe]
    @State private var viewModel = RecipeListViewModel()
    @State private var showAddRecipe = false

    var body: some View {
        @Bindable var routerBind = router
        List {
            ForEach(viewModel.filteredRecipes(recipes)) { recipe in
                NavigationLink(value: recipe) {
                    RecipeRowView(recipe: recipe)
                        .padding(.vertical, 4)
                }
                .accessibilityIdentifier("recipe.row.\(recipe.name)")
                .listRowBackground(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.clear)
                        .glassEffect(in: RoundedRectangle(cornerRadius: 16))
                        .padding(.vertical, 4)
                        .padding(.horizontal, 16)
                )
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(top: 8, leading: 32, bottom: 8, trailing: 32))
            }
            .onDelete(perform: deleteRecipes)
        }
        .accessibilityIdentifier("recipes.list")
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .searchable(text: $viewModel.searchText, prompt: "Search recipes...")
        .navigationTitle("Recipes")
        .navigationDestination(for: Recipe.self) { recipe in
            RecipeDetailView(recipe: recipe)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showAddRecipe = true
                } label: {
                    Image(systemName: "plus")
                }
                .accessibilityIdentifier("recipes.addButton")
                .glassEffect(.regular.interactive(), in: Circle())
            }
        }
        .sheet(isPresented: $showAddRecipe) {
            AddRecipeView(prefill: nil)
        }
        .sheet(item: $routerBind.addRecipePrefill) { params in
            AddRecipeView(prefill: params)
        }
    }

    /// Deletes recipes at the given offsets from the model context.
    ///
    /// Offsets index into the currently *filtered* list (what the user sees), so this resolves
    /// them against ``RecipeListViewModel/filteredRecipes(_:)`` to delete the correct rows when
    /// a search is active.
    private func deleteRecipes(offsets: IndexSet) {
        let filtered = viewModel.filteredRecipes(recipes)
        offsets.forEach { modelContext.delete(filtered[$0]) }
    }
}

struct RecipeRowView: View {
    let recipe: Recipe

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(recipe.name)
                .font(.headline)
            let (hardness, alkalinity) = calculateGHKH(recipe: recipe)
            Text("General Hardness \(hardness) ppm · Alkalinity \(alkalinity) ppm")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}
