import SwiftUI
import SwiftData

struct RootView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(AppRouter.self) private var router
    @Query private var recipes: [Recipe]
    @Query private var settingsArray: [AppSettings]

    var body: some View {
        @Bindable var routerBind = router
        TabView(selection: $routerBind.selectedTab) {
            Tab("Recipes", systemImage: "list.bullet", value: AppTab.recipes) {
                NavigationStack {
                    RecipeListView()
                }
            }
            Tab("Settings", systemImage: "gear", value: AppTab.settings) {
                NavigationStack {
                    SettingsView()
                }
            }
        }
        .onAppear {
            seedIfNeeded()
        }
    }

    /// Seeds first-launch data: inserts the default recipes when none exist and a default
    /// ``AppSettings`` when none exists. Safe to call on every appearance — it no-ops once
    /// the store is populated.
    private func seedIfNeeded() {
        if recipes.isEmpty {
            Recipe.defaults.forEach { modelContext.insert($0) }
        }
        if settingsArray.isEmpty {
            modelContext.insert(AppSettings.default)
        }
    }
}
