import Foundation

/// A count of mineral dropper drops, broken out per mineral, for a given brew.
struct WaterComponents {
    var magnesium: Int
    var calcium: Int
    var potassium: Int
    var sodium: Int
}

/// Derives a recipe's General Hardness (GH) and Alkalinity (KH) from its mineral
/// concentrations.
///
/// - GH (`hardness`) is the sum of magnesium and calcium.
/// - KH (`alkalinity`) is the sum of potassium and sodium.
///
/// - Parameter recipe: The recipe whose mineral concentrations (in ppm as CaCO₃) are summed.
/// - Returns: The integer GH and KH values.
func calculateGHKH(recipe: Recipe) -> (hardness: Int, alkalinity: Int) {
    (
        hardness: Int(recipe.magnesium) + Int(recipe.calcium),
        alkalinity: Int(recipe.potassium) + Int(recipe.sodium)
    )
}

/// Calculates how many Lotus dropper drops of each mineral to add for a given brew volume.
///
/// The recipe concentrations are defined against a 4500 mL reference volume, so they are
/// first scaled linearly by `volumeMl / 4500`. The round (new) Lotus kit dispenses larger
/// drops, so it gets an additional `0.56` correction factor. Potassium and sodium are
/// dosed at double strength because their stock solutions are half the concentration of
/// the calcium/magnesium ones. Results are rounded to whole drops.
///
/// - Parameters:
///   - recipe: The recipe whose mineral concentrations drive the dosing.
///   - volumeMl: The target brew volume in millilitres.
///   - kit: The Lotus mineral kit in use, which determines the drop-size correction.
/// - Returns: The per-mineral drop counts for the chosen volume.
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
