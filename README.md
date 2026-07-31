# iOS XCUITest Portfolio

[![XCUITest CI](https://github.com/gustavaom7/xcuitest-portfolio/actions/workflows/xcode-tests.yml/badge.svg)](https://github.com/gustavaom7/xcuitest-portfolio/actions/workflows/xcode-tests.yml)

Comprehensive UI automation suite for iOS using **XCUITest** framework. Built to demonstrate professional test architecture with **Page Object Pattern**, **accessibility best practices**, and **CI/CD integration**.

> This project is a portfolio artifact showcasing iOS automation expertise aligned with modern QA practices and Swift best practices. Tests run in GitHub Actions — no Xcode installation required locally.

## Why this project

Built to address iOS QA automation requirements:

| Skill | Where in this repo | Status |
|---|---|---|
| Demonstrable knowledge in Swift | `SampleAppUITests/Pages/` + `SampleAppUITests/Tests/` | ✅ |
| XCUITest framework proficiency | Full test suite with best practices | ✅ |
| Page Object Pattern architecture | `BaseTestCase.swift` + `Pages/` structure | ✅ |
| Custom XCTest extensions & utilities | `Utils/XCTestExtensions.swift` | ✅ |
| Accessibility & identifiers usage | `Accessible.swift` identifiers throughout | ✅ |
| CI/CD integration (GitHub Actions) | `.github/workflows/xcode-tests.yml` | ✅ |

## Stack

- **Language**: Swift 5.9+
- **Testing Framework**: XCUITest (native iOS)
- **Test Pattern**: Page Object Model
- **CI/CD**: GitHub Actions + xcodebuild
- **Architecture**: Modular, reusable base classes

## Project Structure

```
xcuitest-portfolio/
├── README.md
├── SETUP.md                              # Local setup guide
├── SampleApp.xcodeproj/                  # Sample iOS app (test target)
│   └── SampleApp/
│       ├── AppDelegate.swift
│       ├── MainViewController.swift
│       └── Resources/
│           └── Assets.xcassets/
│
├── SampleAppUITests/                     # XCUITest test target
│   ├── BaseTestCase.swift                # Shared setup/teardown, waits
│   ├── Pages/                            # Page Object Pattern
│   │   ├── BasePage.swift
│   │   ├── LoginPage.swift
│   │   ├── HomePage.swift
│   │   └── SettingsPage.swift
│   ├── Tests/
│   │   ├── LoginTests.swift
│   │   ├── NavigationTests.swift
│   │   ├── FormValidationTests.swift
│   │   └── AccessibilityTests.swift
│   ├── Utils/
│   │   ├── XCTestExtensions.swift        # Custom assertions
│   │   ├── Accessible.swift              # Accessibility identifiers
│   │   ├── TestData.swift                # Mock data
│   │   └── WaitHelpers.swift             # Synchronization utilities
│   └── Resources/
│       └── Localizable.strings           # Test localization
│
├── .github/workflows/
│   └── xcode-tests.yml                   # CI/CD pipeline
│
├── docs/
│   ├── SETUP.md                          # Installation & configuration
│   ├── PAGE_OBJECTS.md                   # Architecture pattern
│   ├── ACCESSIBILITY.md                  # iOS accessibility best practices
│   ├── ASYNC_HANDLING.md                 # Wait strategies
│   └── CI_CD.md                          # GitHub Actions workflow
│
└── .gitignore
```

## Quick Start

### ⚡ CI/CD Only (No Xcode Required)

This project runs tests **exclusively in GitHub Actions** (cloud). You don't need Xcode installed locally.

**Workflow:**
1. Clone repository
2. Edit code in any editor (VSCode, Vim, etc.)
3. Commit & push to GitHub
4. GitHub Actions runs tests automatically
5. View results in Actions tab

See [CI_CD_ONLY.md](CI_CD_ONLY.md) for detailed setup.

### Quick Push

```bash
# Clone
git clone https://github.com/gustavaom7/xcuitest-portfolio.git
cd xcuitest-portfolio

# Edit any test file
# (VSCode, Sublime, Vim, etc.)

# Commit & push
git add .
git commit -m "Update tests"
git push origin main

# View results
# → GitHub Actions tab → See test status
```

### (Optional) Local Testing with Xcode

If you have Xcode installed:

```bash
# Open in Xcode
open SampleApp.xcodeproj

# Run all tests (⌘U)
# Or: xcodebuild test -scheme SampleApp
```

## Key Features

### 🏗️ Page Object Pattern

Clean separation of test logic from UI interaction:

```swift
// ✅ Bad: Direct XCUIElement interaction in tests
func testLogin() {
    app.textFields["email"].typeText("user@example.com")
    app.secureTextFields["password"].typeText("pass123")
    app.buttons["Login"].tap()
}

// ✅ Good: Page Object encapsulation
let loginPage = LoginPage(app: app)
loginPage.login(email: "user@example.com", password: "pass123")
loginPage.verifyWelcomeMessage()
```

### ⏱️ Smart Wait Strategies

Handles asynchronous UI updates without flaky delays:

```swift
// Custom waits with meaningful timeouts
loginPage.waitForElement(app.staticTexts["Welcome"], timeout: 5.0)

// Optional elements that may/may not appear
app.buttons["Skip Tutorial"].tapIfExists()
```

### ♿ Accessibility-First

Uses accessibility identifiers for robustness:

```swift
// Accessible.swift defines all identifiers
textField(Accessible.Login.emailField).typeText(email)
button(Accessible.Login.submitButton).tap()
```

### 🧪 Comprehensive Test Coverage

- **Functional Tests**: Login, navigation, data entry
- **Negative Tests**: Invalid inputs, error messages
- **Accessibility Tests**: VoiceOver compatibility
- **State Tests**: App state transitions

### 🔄 CI/CD Ready

GitHub Actions workflow runs on:
- Every push/PR
- Daily schedule
- Manual trigger

Generates test reports and uploads artifacts.

## Documentation

- **[CI_CD_ONLY.md](CI_CD_ONLY.md)** - How to work without Xcode (cloud testing)
- **[SETUP.md](docs/SETUP.md)** - Local environment setup (optional, with Xcode)
- **[PAGE_OBJECTS.md](docs/PAGE_OBJECTS.md)** - Architecture & patterns
- **[ACCESSIBILITY.md](docs/ACCESSIBILITY.md)** - iOS a11y best practices
- **[ASYNC_HANDLING.md](docs/ASYNC_HANDLING.md)** - Synchronization strategies
- **[CI_CD.md](docs/CI_CD.md)** - GitHub Actions workflow details

## Test Results

All tests designed to run reliably on iOS Simulator (iPhone 15, iOS 17.5+).

**Expected outcome:**
- ✅ 3+ passing test classes
- ✅ 15+ individual test cases
- ✅ ~3-5 seconds total runtime (simulator)
- ✅ Zero flaky assertions

## Next Steps (Portfolio Enhancements)

- [ ] Video recording on test failure
- [ ] Screenshot comparison for visual regression
- [ ] Performance profiling (XCMetrics)
- [ ] Custom test runner with retry logic
- [ ] Jira/Linear integration for failed tests
- [ ] Support for real device testing (CI agent)

## Requirements

- Xcode 14.0+
- Swift 5.9+
- iOS 16.0+ (simulator or device)
- macOS 13.0+ (for running tests locally)

## License

MIT

---

**Questions?** Check the [docs/](docs/) folder or open an issue.
