import XCTest

class BasePage {

    let app: XCUIApplication

    init(app: XCUIApplication) {
        self.app = app
    }

    // MARK: - Common Element Accessors

    func textField(_ identifier: String) -> XCUIElement {
        app.textFields[identifier]
    }

    func secureTextField(_ identifier: String) -> XCUIElement {
        app.secureTextFields[identifier]
    }

    func button(_ identifier: String) -> XCUIElement {
        app.buttons[identifier]
    }

    func staticText(_ identifier: String) -> XCUIElement {
        app.staticTexts[identifier]
    }

    func switch(_ identifier: String) -> XCUIElement {
        app.switches[identifier]
    }

    // MARK: - Wait Helpers

    func wait(for element: XCUIElement, timeout: TimeInterval = 5.0) {
        let predicate = NSPredicate(format: "exists == true")
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: element)

        _ = XCTWaiter().wait(for: [expectation], timeout: timeout)
    }

    func waitForElementToDisappear(_ element: XCUIElement, timeout: TimeInterval = 5.0) {
        let predicate = NSPredicate(format: "exists == false")
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: element)

        _ = XCTWaiter().wait(for: [expectation], timeout: timeout)
    }

    // MARK: - Common Actions

    func tapButton(_ identifier: String) {
        button(identifier).tap()
    }

    func typeText(_ text: String, into identifier: String) {
        textField(identifier).typeText(text)
    }

    func verifyElementExists(_ identifier: String) -> Bool {
        staticText(identifier).exists
    }
}
