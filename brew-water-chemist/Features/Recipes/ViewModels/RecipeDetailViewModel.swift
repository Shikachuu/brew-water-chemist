import Foundation
import Observation

@Observable class RecipeDetailViewModel {
    var selectedVolumeMl: Int

    init(defaultVolume: Int = 4500) {
        self.selectedVolumeMl = defaultVolume
    }

    /// The per-mineral drop counts for the recipe at the currently selected volume.
    /// - Parameters:
    ///   - recipe: The recipe being viewed.
    ///   - kit: The Lotus mineral kit used to determine drop sizing.
    func droplets(for recipe: Recipe, kit: MineralKit) -> WaterComponents {
        calculateDroplets(recipe: recipe, volumeMl: selectedVolumeMl, kit: kit)
    }

    /// Builds a deep link that encodes the recipe so it can be shared and re-imported.
    ///
    /// The URL uses the `brew-water-chemist://add` scheme with the recipe name and each
    /// mineral concentration as query items, matching what ``AppRouter/handleURL(_:)`` parses.
    ///
    /// - Parameter recipe: The recipe to encode.
    /// - Returns: The share URL, or `nil` if the components could not form a valid URL.
    func shareURL(for recipe: Recipe) -> URL? {
        var components = URLComponents()
        components.scheme = "brew-water-chemist"
        components.host = "add"
        components.queryItems = [
            URLQueryItem(name: "name", value: recipe.name),
            URLQueryItem(name: "calcium", value: String(recipe.calcium)),
            URLQueryItem(name: "magnesium", value: String(recipe.magnesium)),
            URLQueryItem(name: "sodium", value: String(recipe.sodium)),
            URLQueryItem(name: "potassium", value: String(recipe.potassium)),
        ]
        return components.url
    }
}
