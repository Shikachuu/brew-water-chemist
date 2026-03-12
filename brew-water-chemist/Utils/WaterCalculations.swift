import Foundation

struct WaterComponents {
    var magnesium: Int
    var calcium: Int
    var potassium: Int
    var sodium: Int
}

func calculateGHKH(recipe: Recipe) -> (hardness: Int, alkalinity: Int) {
    (
        hardness: Int(recipe.magnesium) + Int(recipe.calcium),
        alkalinity: Int(recipe.potassium) + Int(recipe.sodium)
    )
}

func calculateDroplets(recipe: Recipe, volumeMl: Int, kit: MineralKit) -> WaterComponents {
    let factor = Double(volumeMl) / 4500.0
    let scale = kit == .lotusRound ? factor * 0.56 : factor
    return WaterComponents(
        magnesium: Int((recipe.magnesium * scale).rounded()),
        calcium: Int((recipe.calcium * scale).rounded()),
        potassium: Int((recipe.potassium * scale * 2).rounded()),
        sodium: Int((recipe.sodium * scale * 2).rounded())
    )
}
