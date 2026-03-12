import Foundation
import Observation

@Observable class RecipeListViewModel {
    var searchText: String = ""

    func filteredRecipes(_ recipes: [Recipe]) -> [Recipe] {
        guard !searchText.isEmpty else { return recipes }
        return recipes.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }
}
