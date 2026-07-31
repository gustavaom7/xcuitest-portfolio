import XCTest

class SettingsPage: BasePage {

    // MARK: - Elements

    var darkModeSwitch: XCUIElement {
        app.switches[Accessible.Settings.darkModeSwitch]
    }

    var notificationsSwitch: XCUIElement {
        app.switches[Accessible.Settings.notificationsSwitch]
    }

    var backButton: XCUIElement {
        button(Accessible.Settings.backButton)
    }

    var versionLabel: XCUIElement {
        app.staticTexts[Accessible.Settings.versionLabel]
    }

    // MARK: - Actions

    func toggleDarkMode() {
        darkModeSwitch.tap()
    }

    func toggleNotifications() {
        notificationsSwitch.tap()
    }

    func tapBackButton() {
        backButton.tap()
    }

    // MARK: - Assertions

    func verifySettingsPageLoaded() {
        wait(for: backButton, timeout: 5.0)
        XCTAssertTrue(backButton.exists, "Back button should be visible")
        XCTAssertTrue(darkModeSwitch.exists, "Dark mode switch should be visible")
        XCTAssertTrue(notificationsSwitch.exists, "Notifications switch should be visible")
    }

    func verifyDarkModeToggleVisible() {
        XCTAssertTrue(darkModeSwitch.exists, "Dark mode toggle should be visible")
    }

    func verifyVersionLabelDisplayed() {
        XCTAssertTrue(versionLabel.exists, "Version label should be displayed")
    }
}
