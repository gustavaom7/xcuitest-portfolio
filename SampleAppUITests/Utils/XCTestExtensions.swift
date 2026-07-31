import XCTest

extension XCUIElement {

    /// Checks if element exists without raising assertion
    var isVisible: Bool {
        self.exists && self.isHittable
    }

    /// Safely taps element if it exists
    func tapIfExists() {
        if self.exists {
            self.tap()
        }
    }

    /// Clears text field and enters new text
    func clearAndType(_ text: String) {
        self.tap()
        self.doubleTap() // Select all
        self.typeText(text)
    }

    /// Type text with a delay between characters (useful for special inputs)
    func typeTextSlowly(_ text: String, delayBetweenCharacters: Double = 0.05) {
        for character in text {
            self.typeText(String(character))
            Thread.sleep(forTimeInterval: delayBetweenCharacters)
        }
    }

    /// Wait for element to appear
    func waitForExistence(timeout: TimeInterval = 5.0) -> Bool {
        let predicate = NSPredicate(format: "exists == true")
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: self)
        return XCTWaiter().wait(for: [expectation], timeout: timeout) == .completed
    }

    /// Wait for element to disappear
    func waitForInvisibility(timeout: TimeInterval = 5.0) -> Bool {
        let predicate = NSPredicate(format: "exists == false")
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: self)
        return XCTWaiter().wait(for: [expectation], timeout: timeout) == .completed
    }
}

extension XCUIApplication {

    /// Get all text in the current view hierarchy
    func allVisibleText() -> String {
        var text = ""
        for window in self.windows {
            text += self.collectText(from: window)
        }
        return text
    }

    private func collectText(from element: XCUIElement) -> String {
        var text = ""

        if !element.label.isEmpty {
            text += element.label + " "
        }

        for child in element.children {
            text += self.collectText(from: child)
        }

        return text
    }
}

extension XCTestCase {

    /// Assert element exists with custom message
    func assertElementExists(_ element: XCUIElement, _ message: String = "Element should exist") {
        XCTAssertTrue(element.exists, message)
    }

    /// Assert element does not exist with custom message
    func assertElementNotExists(_ element: XCUIElement, _ message: String = "Element should not exist") {
        XCTAssertFalse(element.exists, message)
    }

    /// Assert element contains text
    func assertElementContainsText(_ element: XCUIElement, _ text: String, _ message: String? = nil) {
        let msg = message ?? "Element should contain text: '\(text)'"
        XCTAssertTrue(element.label.contains(text), msg)
    }

    /// Screenshot for debugging
    func takeScreenshot(name: String = "screenshot") {
        let screenshot = XCUIScreen.main.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = name
        attachment.lifetime = .keepAlways
        self.add(attachment)
    }
}
