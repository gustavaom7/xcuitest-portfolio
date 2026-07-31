import Foundation

/// Centralized accessibility identifiers for all UI elements.
/// Using a single source of truth ensures consistency between app and tests.
///
/// Structure:
/// - Each screen/feature has its own nested struct
/// - Identifiers follow pattern: [Screen][ElementType][ElementName]
/// - Example: loginEmailTextField → Accessible.Login.emailField

struct Accessible {

    struct Login {
        static let emailField = "loginEmailTextField"
        static let passwordField = "loginPasswordTextField"
        static let loginButton = "loginSubmitButton"
        static let errorMessage = "loginErrorMessage"
        static let rememberMeSwitch = "loginRememberMeSwitch"
        static let forgotPasswordButton = "loginForgotPasswordButton"
    }

    struct Home {
        static let welcomeLabel = "homeWelcomeLabel"
        static let userNameLabel = "homeUserNameLabel"
        static let logoutButton = "homeLogoutButton"
        static let settingsButton = "homeSettingsButton"
        static let contentView = "homeContentView"
    }

    struct Settings {
        static let darkModeSwitch = "settingsDarkModeSwitch"
        static let notificationsSwitch = "settingsNotificationsSwitch"
        static let backButton = "settingsBackButton"
        static let versionLabel = "settingsVersionLabel"
    }

    struct Common {
        static let navigationBar = "navigationBar"
        static let loadingSpinner = "loadingSpinner"
        static let alertOKButton = "alertOKButton"
        static let alertCancelButton = "alertCancelButton"
    }
}
