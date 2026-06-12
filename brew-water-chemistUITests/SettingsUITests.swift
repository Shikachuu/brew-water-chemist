import XCTest

/// Covers settings management (quantities + mineral kit) and the deep-link / QR import flow.
final class SettingsUITests: UITestCase {

    @MainActor
    private func openSettings() {
        app.tabBars.buttons["Settings"].tap()
    }

    @MainActor
    func testAddQuantity() {
        launch()
        openSettings()

        app.buttons["settings.addQuantity"].tap()

        let field = app.textFields["addQuantity.field"]
        field.assertAppears()
        field.tap()
        field.typeText("750")

        app.buttons["addQuantity.add"].tap()

        XCTAssertTrue(app.staticTexts["settings.quantity.750"].assertAppears())
    }

    @MainActor
    func testAddQuantityValidation() {
        launch()
        openSettings()

        app.buttons["settings.addQuantity"].tap()

        let add = app.buttons["addQuantity.add"]
        add.assertAppears()
        XCTAssertFalse(add.isEnabled, "Add should be disabled with no input")

        let field = app.textFields["addQuantity.field"]
        field.tap()
        field.typeText("0")
        XCTAssertFalse(add.isEnabled, "Add should stay disabled for a non-positive value")
    }

    @MainActor
    func testDeleteQuantity() {
        launch()
        openSettings()

        let row = app.staticTexts["settings.quantity.500"]
        row.assertAppears()
        row.swipeLeft()
        app.buttons["Delete"].tap()

        app.staticTexts["settings.quantity.500"].assertDisappears()
    }

    @MainActor
    func testSwitchMineralKit() {
        launch()
        openSettings()

        let picker = app.buttons["settings.mineralKit"]
        picker.assertAppears()
        picker.tap()

        app.buttons["Lotus (old, straight)"].tap()

        XCTAssertTrue(picker.label.contains("Lotus (old, straight)"))
    }

    @MainActor
    func testDeepLinkPrefillsAndSaves() {
        let url = "brew-water-chemist://add?name=Shared%20Recipe&calcium=40&magnesium=10&potassium=5&sodium=5"
        launch(openURL: url)

        // The deep link routes to the recipes tab and opens the add sheet, prefilled.
        let nameField = app.textFields["addRecipe.name"]
        nameField.assertAppears()
        XCTAssertEqual(nameField.value as? String, "Shared Recipe")

        app.buttons["addRecipe.save"].tap()

        XCTAssertTrue(app.staticTexts["Shared Recipe"].assertAppears())
    }
}
