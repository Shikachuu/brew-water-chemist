import XCTest

/// Covers the recipe list: search filtering and swipe-to-delete (including with a filter active).
final class RecipeListUITests: UITestCase {

    @MainActor
    func testSearchFiltersList() {
        launch()
        XCTAssertTrue(app.staticTexts["Bright and Juicy"].assertAppears())
        XCTAssertTrue(app.staticTexts["Rao/Perger"].exists)

        let search = app.searchFields.firstMatch
        search.assertAppears()
        search.tap()
        search.typeText("Juicy")

        XCTAssertTrue(app.staticTexts["Bright and Juicy"].assertAppears())
        app.staticTexts["Rao/Perger"].assertDisappears()
    }

    @MainActor
    func testSwipeToDelete() {
        launch()
        let row = app.staticTexts["Light and Bright"]
        row.assertAppears()

        row.swipeLeft()
        app.buttons["Delete"].tap()

        app.staticTexts["Light and Bright"].assertDisappears()
        // A different recipe sharing the substring is unaffected.
        XCTAssertTrue(app.staticTexts["Espresso Light and Bright"].exists)
    }

    @MainActor
    func testDeleteCorrectRowWhileFiltered() {
        launch()
        let search = app.searchFields.firstMatch
        search.assertAppears()
        search.tap()
        search.typeText("Apax")

        // Two defaults match "Apax"; delete one and confirm only it is removed.
        let washed = app.staticTexts["Apax Lab Washed Coffees"]
        washed.assertAppears()
        washed.swipeLeft()
        app.buttons["Delete"].tap()

        washed.assertDisappears()
        XCTAssertTrue(app.staticTexts["Apax Lab Natural Processed Coffees"].exists)
    }
}
