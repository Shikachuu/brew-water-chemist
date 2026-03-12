import Testing
@testable import brew_water_chemist

struct WaterCalculationTests {
    let recipe = Recipe(name: "Test", magnesium: 10, calcium: 15, potassium: 5, sodium: 5)

    @Test func ghkh() {
        let (hardness, alkalinity) = calculateGHKH(recipe: recipe)
        #expect(hardness == 25)
        #expect(alkalinity == 10)
    }

    @Test func droplets_lotusRound_4500mL() {
        let drops = calculateDroplets(recipe: recipe, volumeMl: 4500, kit: .lotusRound)
        // scale = 1.0 * 0.56 = 0.56
        #expect(drops.magnesium == 6)  // 10 * 0.56 = 5.6 → 6
        #expect(drops.calcium == 8)    // 15 * 0.56 = 8.4 → 8
        #expect(drops.potassium == 6)  // 5 * 0.56 * 2 = 5.6 → 6
        #expect(drops.sodium == 6)     // 5 * 0.56 * 2 = 5.6 → 6
    }

    @Test func droplets_lotusStraight_4500mL() {
        let drops = calculateDroplets(recipe: recipe, volumeMl: 4500, kit: .lotusStraight)
        // scale = 1.0
        #expect(drops.magnesium == 10)
        #expect(drops.calcium == 15)
        #expect(drops.potassium == 10) // 5 * 1.0 * 2
        #expect(drops.sodium == 10)    // 5 * 1.0 * 2
    }

    @Test func droplets_halfVolume_lotusStraight() {
        let drops = calculateDroplets(recipe: recipe, volumeMl: 2250, kit: .lotusStraight)
        // scale = 0.5
        #expect(drops.magnesium == 5)  // 10 * 0.5 = 5
        #expect(drops.calcium == 8)    // 15 * 0.5 = 7.5 → 8
        #expect(drops.potassium == 5)  // 5 * 0.5 * 2 = 5
        #expect(drops.sodium == 5)
    }

    @Test func droplets_quarterVolume_lotusRound() {
        let drops = calculateDroplets(recipe: recipe, volumeMl: 1125, kit: .lotusRound)
        // scale = 0.25 * 0.56 = 0.14
        #expect(drops.magnesium == Int((10.0 * 0.14).rounded()))
        #expect(drops.calcium == Int((15.0 * 0.14).rounded()))
        #expect(drops.potassium == Int((5.0 * 0.14 * 2).rounded()))
        #expect(drops.sodium == Int((5.0 * 0.14 * 2).rounded()))
    }
}
