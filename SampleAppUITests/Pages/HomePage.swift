import XCTest

class HomePage: BasePage {

    // MARK: - Elements

    var welcomeLabel: XCUIElement {
        app.staticTexts[Accessible.Home.welcomeLabel]
    }

    var logoutButton: XCUIElement {
        button(Accessible.Home.logoutButton)
    }

    var settingsButton: XCUIElement {
        button(Accessible.Home.settingsButton)
    }

    var userNameLabel: XCUIElement {
        app.staticTexts[Accessible.Home.userNameLabel]
    }

    // MARK: - Actions

    func tapLogout() {
        logoutButton.tap()
    }

    func tapSettings() {
        settingsButton.tap()
    }

    // MARK: - Assertions

    func verifyHomePageLoaded() {
        wait(for: welcomeLabel, timeout: 5.0)
        XCTAssertTrue(welcomeLabel.exists, "Welcome label should be visible")
        XCTAssertTrue(logoutButton.exists, "Logout button should be visible")
    }

    func verifyWelcomeMessage(_ expectedMessage: String? = nil) {
        if let expected = expectedMessage {
            XCTAssertTrue(welcomeLabel.label.contains(expected), "Welcome message should contain: \(expected)")
        } else {
            XCTAssertTrue(welcomeLabel.exists, "Welcome label should be displayed")
        }
    }

    func verifyUserNameDisplayed(_ userName: String) {
        XCTAssertTrue(userNameLabel.label.contains(userName), "User name '\(userName)' should be displayed")
    }

    func verifySettingsButtonVisible() {
        XCTAssertTrue(settingsButton.exists, "Settings button should be visible")
    }
}
