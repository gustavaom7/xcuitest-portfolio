# Page Object Model Pattern

## Overview

The **Page Object Model (POM)** is a design pattern that abstracts UI elements and interactions into reusable objects. This makes tests more maintainable, readable, and resistant to UI changes.

## Structure

### BasePage.swift

Abstract base class containing common functionality:

```swift
class BasePage {
    let app: XCUIApplication
    
    // Common element accessors
    func textField(_ identifier: String) -> XCUIElement
    func button(_ identifier: String) -> XCUIElement
    func staticText(_ identifier: String) -> XCUIElement
    
    // Common waits
    func wait(for element: XCUIElement, timeout: TimeInterval = 5.0)
    
    // Common actions
    func tapButton(_ identifier: String)
    func typeText(_ text: String, into identifier: String)
}
```

### Concrete Page Objects (LoginPage, HomePage, etc.)

Each page extends `BasePage` and encapsulates:

**Elements** - UI element definitions:
```swift
var emailTextField: XCUIElement {
    textField(Accessible.Login.emailField)
}
```

**Actions** - User interactions:
```swift
func login(email: String, password: String) {
    enterEmail(email)
    enterPassword(password)
    tapLogin()
}
```

**Assertions** - Verification methods:
```swift
func verifyHomePageLoaded() {
    wait(for: welcomeLabel, timeout: 5.0)
    XCTAssertTrue(welcomeLabel.exists)
}
```

## Benefits

### 1. **Readability**

❌ **Without POM:**
```swift
func testLogin() {
    app.textFields["email"].typeText("user@example.com")
    app.secureTextFields["password"].typeText("pass123")
    app.buttons["Login"].tap()
    XCTAssertTrue(app.staticTexts["Welcome"].exists)
}
```

✅ **With POM:**
```swift
func testLogin() {
    let loginPage = LoginPage(app: app)
    loginPage.login(email: "user@example.com", password: "pass123")
    let homePage = HomePage(app: app)
    homePage.verifyHomePageLoaded()
}
```

### 2. **Maintainability**

If email field identifier changes:
- **Without POM**: Update every test file
- **With POM**: Update `LoginPage.swift` only

### 3. **Reusability**

Tests can compose page objects:

```swift
func testUserSettings() {
    let loginPage = LoginPage(app: app)
    loginPage.login(email: email, password: password)
    
    let homePage = HomePage(app: app)
    homePage.tapSettings()
    
    let settingsPage = SettingsPage(app: app)
    settingsPage.verifySettingsPageLoaded()
    settingsPage.toggleDarkMode()
}
```

### 4. **Consistency**

All interactions follow the same pattern, making code easier to understand and extend.

## Best Practices

### 1. One Page = One Screen

```swift
// LoginPage.swift - handles login screen only
// HomePage.swift - handles home screen only
// SettingsPage.swift - handles settings screen only
```

### 2. Accessibility Identifiers

Always use identifiers defined in `Accessible.swift`:

```swift
// ✅ Good
var emailField: XCUIElement {
    textField(Accessible.Login.emailField)
}

// ❌ Bad
var emailField: XCUIElement {
    app.textFields["email address field"]
}
```

### 3. Separate Actions from Assertions

```swift
// ✅ Good - clear separation
func login(email: String, password: String) {
    enterEmail(email)
    enterPassword(password)
    tapLogin()
}

func verifyHomePageLoaded() {
    wait(for: welcomeLabel)
    XCTAssertTrue(welcomeLabel.exists)
}

// ❌ Bad - mixing concerns
func loginAndVerify(email: String, password: String) {
    enterEmail(email)
    enterPassword(password)
    tapLogin()
    XCTAssertTrue(app.staticTexts["Welcome"].exists)
}
```

### 4. Meaningful Method Names

```swift
// ✅ Good - describes what happens
func loginWithValidCredentials()
func verifyErrorMessageDisplayed()
func toggleDarkMode()

// ❌ Bad - vague or unclear
func test1()
func doSomething()
func click()
```

### 5. Element Lazy Loading

Define elements as computed properties so they're always fresh:

```swift
// ✅ Good
var emailTextField: XCUIElement {
    textField(Accessible.Login.emailField)
}

// ❌ Bad - stale reference
var emailTextField: XCUIElement {
    let field = textField(Accessible.Login.emailField)
    return field
}
```

## Common Page Object Patterns

### Fluent Interface (Method Chaining)

```swift
class LoginPage: BasePage {
    func enterEmail(_ email: String) -> LoginPage {
        emailTextField.typeText(email)
        return self
    }
    
    func enterPassword(_ password: String) -> LoginPage {
        passwordTextField.typeText(password)
        return self
    }
}

// Usage
let loginPage = LoginPage(app: app)
loginPage
    .enterEmail("user@example.com")
    .enterPassword("password123")
    .tapLogin()
```

### Navigation Between Pages

```swift
class HomePage: BasePage {
    func navigateToSettings() -> SettingsPage {
        settingsButton.tap()
        return SettingsPage(app: app)
    }
}

// Usage
let settingsPage = homePage.navigateToSettings()
settingsPage.verifySettingsPageLoaded()
```

### Modal/Alert Handling

```swift
class AlertPage: BasePage {
    var okButton: XCUIElement {
        button(Accessible.Common.alertOKButton)
    }
    
    func tapOK() {
        okButton.tap()
    }
}

// Usage
if app.alerts.count > 0 {
    let alert = AlertPage(app: app)
    alert.tapOK()
}
```

## Testing Page Objects

Page objects themselves should be tested for element visibility:

```swift
func testLoginPageElementsVisible() {
    let loginPage = LoginPage(app: app)
    loginPage.verifyLoginPageLoaded()
    // This verifies all critical elements are present
}
```

## Anti-Patterns

### ❌ Test Logic in Page Objects

```swift
// Bad - page object doing test assertions
func login(email: String, password: String) {
    enterEmail(email)
    enterPassword(password)
    tapLogin()
    XCTAssertTrue(welcomeLabel.exists)  // ← Test logic!
}
```

### ❌ Over-Abstraction

```swift
// Bad - abstraction that's too generic
func clickElement(_ id: String) {
    app.buttons[id].tap()
}
```

### ❌ Heavy State Management

```swift
// Bad - page object tracking state
class LoginPage: BasePage {
    var currentEmail: String = ""
    var loginAttempts = 0
}
```

## Scaling Page Objects

For large applications, organize pages hierarchically:

```
SampleAppUITests/Pages/
├── BasePage.swift
├── Authentication/
│   ├── LoginPage.swift
│   └── SignupPage.swift
├── Home/
│   ├── HomePage.swift
│   └── ProfilePage.swift
└── Settings/
    ├── SettingsPage.swift
    └── PrivacyPage.swift
```

## Summary

| Benefit | Details |
|---------|---------|
| **Maintainability** | Changes to UI only require updating page objects |
| **Readability** | Tests read like business logic, not UI code |
| **Reusability** | Page objects used across multiple tests |
| **Scalability** | Easy to add new pages as app grows |
| **Reliability** | Centralized waits and synchronization |

By consistently applying POM patterns, you create a sustainable, scalable automation framework.
