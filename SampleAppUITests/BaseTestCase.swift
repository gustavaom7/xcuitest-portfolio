import XCTest

class BaseTestCase: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()

        // Continue after failure to collect more diagnostics
        continueAfterFailure = false

        // Launch app fresh for each test
        app = XCUIApplication()

        // Set launch arguments/environment
        app.launchArguments = ["-com.apple.CoreData.Logging.stderr", "1"]
        app.launchEnvironment = ["isTestMode": "true"]

        app.launch()

        // Wait for app to stabilize
        Thread.sleep(forTimeInterval: 0.5)
    }

    override func tearDownWithError() throws {
        app.terminate()
        try super.tearDownWithError()
    }

    // MARK: - Wait Helpers

    func wait(for element: XCUIElement, timeout: TimeInterval = 5.0, expectation message: String) {
        let predicate = NSPredicate(format: "exists == true")
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: element)

        let result = XCTWaiter().wait(for: [expectation], timeout: timeout)

        if result == .timedOut {
            XCTFail("Timed out waiting for element: \(message)")
        }
    }

    func waitForElementToDisappear(_ element: XCUIElement, timeout: TimeInterval = 5.0) {
        let predicate = NSPredicate(format: "exists == false")
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: element)

        let result = XCTWaiter().wait(for: [expectation], timeout: timeout)

        if result == .timedOut {
            XCTFail("Timed out waiting for element to disappear")
        }
    }
}
