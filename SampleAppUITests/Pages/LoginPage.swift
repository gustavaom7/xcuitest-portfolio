import XCTest

class LoginPage: BasePage {

    // MARK: - Elements

    var emailTextField: XCUIElement {
        textField(Accessible.Login.emailField)
    }

    var passwordTextField: XCUIElement {
        secureTextField(Accessible.Login.passwordField)
    }

    var loginButton: XCUIElement {
        button(Accessible.Login.loginButton)
    }

    var errorMessage: XCUIElement {
        app.staticTexts[Accessible.Login.errorMessage]
    }

    var rememberMeSwitch: XCUIElement {
        app.switches[Accessible.Login.rememberMeSwitch]
    }

    // MARK: - Actions

    func enterEmail(_ email: String) {
        emailTextField.tap()
        emailTextField.typeText(email)
    }

    func enterPassword(_ password: String) {
        passwordTextField.tap()
        passwordTextField.typeText(password)
    }

    func tapLogin() {
        loginButton.tap()
    }

    func toggleRememberMe() {
        rememberMeSwitch.tap()
    }

    func clearEmailField() {
        emailTextField.tap()
        // Select all and delete
        app.menuItems["Select All"].tap()
        app.keys["delete"].tap()
    }

    func login(email: String, password: String) {
        enterEmail(email)
        enterPassword(password)
        tapLogin()
    }

    // MARK: - Assertions

    func verifyLoginPageLoaded() {
        wait(for: emailTextField, timeout: 5.0)
        XCTAssertTrue(emailTextField.exists, "Email field should be visible")
        XCTAssertTrue(passwordTextField.exists, "Password field should be visible")
        XCTAssertTrue(loginButton.exists, "Login button should be visible")
    }

    func verifyErrorMessageDisplayed(_ expectedMessage: String? = nil) {
        wait(for: errorMessage, timeout: 3.0)
        XCTAssertTrue(errorMessage.exists, "Error message should be displayed")

        if let expected = expectedMessage {
            XCTAssertTrue(errorMessage.label.contains(expected), "Error message should contain: \(expected)")
        }
    }

    func verifyErrorMessageNotDisplayed() {
        XCTAssertFalse(errorMessage.exists, "Error message should not be displayed")
    }

    func verifyLoginButtonEnabled() {
        XCTAssertTrue(loginButton.isEnabled, "Login button should be enabled")
    }

    func verifyLoginButtonDisabled() {
        XCTAssertFalse(loginButton.isEnabled, "Login button should be disabled")
    }
}
