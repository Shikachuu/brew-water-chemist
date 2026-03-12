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
