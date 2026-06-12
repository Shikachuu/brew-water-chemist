import XCTest

/// Base class for the app's UI tests.
///
/// Each test launches a fresh `XCUIApplication` with the `-uitest-reset` argument so the app
/// runs against an isolated in-memory SwiftData store, seeded on launch with the known
/// defaults (6 recipes + default settings). Tests therefore always start from the same state.
class UITestCase: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["-uitest-reset"]
    }

    override func tearDownWithError() throws {
        app = nil
    }

    /// Launches the app, optionally injecting a deep link the app handles on appear
    /// (mirrors a scanned QR / `onOpenURL`).
    @discardableResult
    func launch(openURL: String? = nil) -> XCUIApplication {
        if let openURL {
            app.launchEnvironment["UITEST_OPEN_URL"] = openURL
        }
        app.launch()
        return app
    }
}

extension XCUIElement {
    /// Waits for the element to appear, failing the test with a clear message if it doesn't.
    @discardableResult
    func assertAppears(
        timeout: TimeInterval = 5,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> Bool {
        let exists = waitForExistence(timeout: timeout)
        if !exists {
            XCTFail("Expected element \(self) to appear within \(timeout)s", file: file, line: line)
        }
        return exists
    }

    /// Asserts the element goes away (or never appears) within the timeout.
    func assertDisappears(
        timeout: TimeInterval = 3,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let gone = NSPredicate(format: "exists == false")
        let expectation = XCTNSPredicateExpectation(predicate: gone, object: self)
        let result = XCTWaiter().wait(for: [expectation], timeout: timeout)
        if result != .completed {
            XCTFail("Expected element \(self) to disappear within \(timeout)s", file: file, line: line)
        }
    }
}
