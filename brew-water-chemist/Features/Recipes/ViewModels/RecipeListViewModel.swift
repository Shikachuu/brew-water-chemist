import Foundation
import Observation

@Observable class RecipeListViewModel {
    var searchText: String = ""

    /// Filters recipes by the current ``searchText``, matching the name case-insensitively.
    /// Returns the full list unchanged when the search field is empty.
    func filteredRecipes(_ recipes: [Recipe]) -> [Recipe] {
        guard !searchText.isEmpty else { return recipes }
        return recipes.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }
}
