import XCTest

/// Covers the add-recipe flow: list → + → fill form → save → row appears, plus validation.
final class AddRecipeUITests: UITestCase {

    @MainActor
    func testAddRecipeAppearsInList() {
        launch()

        app.buttons["recipes.addButton"].tap()

        let nameField = app.textFields["addRecipe.name"]
        nameField.assertAppears()
        nameField.tap()
        nameField.typeText("My Test Blend")

        let calcium = app.textFields["addRecipe.calcium"]
        calcium.tap()
        calcium.typeText("50")

        app.buttons["addRecipe.save"].tap()

        XCTAssertTrue(app.staticTexts["My Test Blend"].assertAppears())
    }

    @MainActor
    func testSaveDisabledWithEmptyName() {
        launch()

        app.buttons["recipes.addButton"].tap()

        let save = app.buttons["addRecipe.save"]
        save.assertAppears()
        XCTAssertFalse(save.isEnabled, "Save should be disabled when the name is empty")
    }

    @MainActor
    func testCancelDoesNotAddRecipe() {
        launch()

        app.buttons["recipes.addButton"].tap()

        let nameField = app.textFields["addRecipe.name"]
        nameField.assertAppears()
        nameField.tap()
        nameField.typeText("Discarded Blend")

        app.buttons["addRecipe.cancel"].tap()

        app.staticTexts["Discarded Blend"].assertDisappears()
    }
}
