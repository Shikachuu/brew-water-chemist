import Foundation
import SwiftData

@Model final class Recipe {
    var id: UUID
    var name: String
    var magnesium: Double
    var calcium: Double
    var potassium: Double
    var sodium: Double

    init(
        id: UUID = UUID(),
        name: String,
        magnesium: Double,
        calcium: Double,
        potassium: Double,
        sodium: Double
    ) {
        self.id = id
        self.name = name
        self.magnesium = magnesium
        self.calcium = calcium
        self.potassium = potassium
        self.sodium = sodium
    }

    /// The built-in starter recipes seeded on first launch and restored by "Reset to Defaults".
    static var defaults: [Recipe] {
        [
            Recipe(name: "Light and Bright", magnesium: 0, calcium: 60, potassium: 25, sodium: 0),
            Recipe(name: "Espresso Light and Bright", magnesium: 20, calcium: 0, potassium: 45, sodium: 0),
            Recipe(name: "Bright and Juicy", magnesium: 36, calcium: 36, potassium: 9, sodium: 9),
            Recipe(name: "Rao/Perger", magnesium: 60, calcium: 27.2, potassium: 20, sodium: 20),
            Recipe(name: "Apax Lab Washed Coffees", magnesium: 60, calcium: 30, potassium: 0, sodium: 10),
            Recipe(name: "Apax Lab Natural Processed Coffees", magnesium: 45, calcium: 45, potassium: 0, sodium: 10),
        ]
    }
}
