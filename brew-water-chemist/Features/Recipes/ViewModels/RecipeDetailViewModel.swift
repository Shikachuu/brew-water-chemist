import Foundation
import Observation

@Observable class RecipeDetailViewModel {
    var selectedVolumeMl: Int

    init(defaultVolume: Int = 4500) {
        self.selectedVolumeMl = defaultVolume
    }

    func droplets(for recipe: Recipe, kit: MineralKit) -> WaterComponents {
        calculateDroplets(recipe: recipe, volumeMl: selectedVolumeMl, kit: kit)
    }

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
