import XCTest

/// Covers recipe detail: GH/KH summary, volume-driven drop recalculation, and the share sheet.
///
/// Expected values are derived from the seeded "Bright and Juicy" default
/// (Ca 36, Mg 36, K 9, Na 9) with the round Lotus kit:
///   GH = Mg + Ca = 72, KH = K + Na = 18.
///   Calcium drops = round(36 · volume/4500 · 0.56) → 2 at 500 mL, 20 at 4500 mL.
final class RecipeDetailUITests: UITestCase {

    @MainActor
    func testSummaryValuesRender() {
        launch()
        app.staticTexts["Bright and Juicy"].tap()

        // General Hardness = 72 (the detail summary card, not the list caption).
        XCTAssertTrue(app.staticTexts["72"].assertAppears())
    }

    @MainActor
    func testVolumeSelectionRecalculatesDrops() {
        launch()
        app.staticTexts["Bright and Juicy"].tap()

        let calcium = app.staticTexts["mineral.calcium.value"]
        calcium.assertAppears()
        // Detail opens at the first quantity (500 mL).
        XCTAssertEqual(calcium.label, "2")

        app.buttons["volume.4500"].tap()
        XCTAssertEqual(calcium.label, "20")
    }

    @MainActor
    func testShareSheetShowsQRCode() {
        launch()
        app.staticTexts["Bright and Juicy"].tap()

        app.buttons["detail.shareButton"].tap()

        XCTAssertTrue(app.images["share.qrCode"].assertAppears())
    }
}
