import XCTest

class NavigationTests: BaseTestCase {

    var loginPage: LoginPage!
    var homePage: HomePage!

    override func setUpWithError() throws {
        try super.setUpWithError()
        loginPage = LoginPage(app: app)
        homePage = HomePage(app: app)
    }

    // MARK: - Navigation Tests

    func testNavigateFromLoginToHome() {
        // Arrange
        loginPage.verifyLoginPageLoaded()

        // Act
        loginPage.login(
            email: TestData.ValidCredentials.email,
            password: TestData.ValidCredentials.password
        )

        // Assert
        homePage.verifyHomePageLoaded()
    }

    func testLoginPageShownWhenAppLaunches() {
        // Assert
        loginPage.verifyLoginPageLoaded()
    }

    func testLogoutNavigatesBackToLogin() {
        // Arrange
        loginPage.login(
            email: TestData.ValidCredentials.email,
            password: TestData.ValidCredentials.password
        )
        homePage.verifyHomePageLoaded()

        // Act
        homePage.tapLogout()

        // Assert
        loginPage.verifyLoginPageLoaded()
    }

    func testSettingsNavigationFromHome() {
        // Arrange
        loginPage.login(
            email: TestData.ValidCredentials.email,
            password: TestData.ValidCredentials.password
        )
        homePage.verifyHomePageLoaded()

        // Act
        homePage.tapSettings()

        // Assert
        let settingsPage = SettingsPage(app: app)
        settingsPage.verifySettingsPageLoaded()
    }

    // MARK: - Back Navigation Tests

    func testBackFromSettingsToHome() {
        // Arrange
        loginPage.login(
            email: TestData.ValidCredentials.email,
            password: TestData.ValidCredentials.password
        )
        homePage.verifyHomePageLoaded()
        let settingsPage = SettingsPage(app: app)
        homePage.tapSettings()
        settingsPage.verifySettingsPageLoaded()

        // Act
        settingsPage.tapBackButton()

        // Assert
        homePage.verifyHomePageLoaded()
    }

    // MARK: - Navigation State Tests

    func testUserDataPersistsAfterSettingsNavigation() {
        // Arrange
        loginPage.login(
            email: TestData.ValidCredentials.email,
            password: TestData.ValidCredentials.password
        )
        homePage.verifyHomePageLoaded()
        homePage.verifyUserNameDisplayed(TestData.ValidCredentials.userName)

        // Act
        homePage.tapSettings()
        let settingsPage = SettingsPage(app: app)
        settingsPage.verifySettingsPageLoaded()
        settingsPage.tapBackButton()

        // Assert
        homePage.verifyUserNameDisplayed(TestData.ValidCredentials.userName)
    }
}
