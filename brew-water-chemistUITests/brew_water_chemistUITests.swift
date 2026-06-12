//
//  brew_water_chemistUITests.swift
//  brew-water-chemistUITests
//
//  Created by Máté Czékus on 2026. 03. 12..
//

import XCTest

/// Smoke + performance checks. The real flow coverage lives in the per-feature
/// `*UITests` files (Add/Detail/List/Settings).
final class brew_water_chemistUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testLaunches() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-uitest-reset"]
        app.launch()

        // The recipes tab and its seeded content should be present on launch.
        XCTAssertTrue(app.navigationBars["Recipes"].waitForExistence(timeout: 5))
    }

    @MainActor
    func testLaunchPerformance() throws {
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
