import Foundation
import Observation

enum AppTab: Hashable {
    case recipes
    case settings
}

struct AddRecipeParams: Identifiable {
    let id = UUID()
    var name: String
    var calcium: Double
    var magnesium: Double
    var sodium: Double
    var potassium: Double
}

@Observable class AppRouter {
    var selectedTab: AppTab = .recipes
    var addRecipePrefill: AddRecipeParams?

    /// Handles an incoming `brew-water-chemist://add` deep link by prefilling a new recipe.
    ///
    /// Parses the recipe name and mineral concentrations from the URL's query items (missing
    /// or unparseable minerals default to `0`), stores them in ``addRecipePrefill`` to trigger
    /// the add-recipe sheet, and switches to the recipes tab. Links that don't match the
    /// expected scheme/host are ignored.
    ///
    /// - Parameter url: The deep link to handle, typically produced by ``RecipeDetailViewModel/shareURL(for:)``.
    func handleURL(_ url: URL) {
        guard url.scheme == "brew-water-chemist",
              url.host == "add",
              let items = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems
        else { return }

        func value(_ name: String) -> String { items.first(where: { $0.name == name })?.value ?? "" }

        addRecipePrefill = AddRecipeParams(
            name: value("name"),
            calcium: Double(value("calcium")) ?? 0,
            magnesium: Double(value("magnesium")) ?? 0,
            sodium: Double(value("sodium")) ?? 0,
            potassium: Double(value("potassium")) ?? 0
        )
        selectedTab = .recipes
    }
}
