# XCUITest Setup Guide

## Prerequisites

- **Xcode**: 14.0 or later
- **Swift**: 5.9+
- **macOS**: 13.0+
- **iOS**: 16.0+ (for simulator/device)

Check your Xcode version:
```bash
xcode-select --print-path
xcodebuild -version
```

## Local Setup

### 1. Clone the Repository

```bash
git clone https://github.com/gustavaom7/xcuitest-portfolio.git
cd xcuitest-portfolio
```

### 2. Open in Xcode

```bash
open SampleApp.xcodeproj
```

Or simply double-click `SampleApp.xcodeproj` in Finder.

### 3. Select Simulator

In Xcode:
- Top toolbar → Select target device (e.g., iPhone 15)
- Or: Product → Destination → Choose simulator

### 4. Run Tests

**Using Xcode UI:**
- ⌘U → Run all tests
- Click diamond icon next to test class → Run specific test

**Using Terminal:**

```bash
# Run all tests
xcodebuild test -scheme SampleApp

# Run specific test class
xcodebuild test -scheme SampleApp -only-testing SampleAppUITests/LoginTests

# Run with specific device
xcodebuild test \
  -scheme SampleApp \
  -destination 'platform=iOS Simulator,name=iPhone 15,OS=17.5'

# Generate test report (JUnit XML)
xcodebuild test \
  -scheme SampleApp \
  -resultBundlePath test-results.xcresult \
  -resultBundleVersion 3
```

## Project Structure

### Main App (`SampleApp/`)

Minimal iOS app for testing. Contains:
- **AppDelegate.swift** - App lifecycle
- **MainViewController.swift** - Login/home screen logic
- **Assets.xcassets** - Images, app icon

### Test Target (`SampleAppUITests/`)

XCUITest suite organized by concern:

```
SampleAppUITests/
├── BaseTestCase.swift           # Test base class (setup/teardown)
├── Pages/                       # Page Object classes
│   ├── BasePage.swift           # Abstract base page
│   ├── LoginPage.swift
│   ├── HomePage.swift
│   └── SettingsPage.swift
├── Tests/                       # Test classes
│   ├── LoginTests.swift
│   ├── NavigationTests.swift
│   ├── FormValidationTests.swift
│   └── AccessibilityTests.swift
└── Utils/                       # Helpers & extensions
    ├── XCTestExtensions.swift
    ├── Accessible.swift
    ├── TestData.swift
    └── WaitHelpers.swift
```

## Common Tasks

### Add a New Test

1. Create test file: `SampleAppUITests/Tests/MyNewTests.swift`
2. Inherit from `BaseTestCase`

```swift
import XCTest

class MyNewTests: BaseTestCase {
    
    override func setUp() {
        super.setUp()
        // Additional setup for this test class
    }
    
    func testExample() {
        let page = HomePage(app: app)
        page.verifyHomePageLoaded()
    }
}
```

### Add a New Page Object

1. Create page file: `SampleAppUITests/Pages/MyPage.swift`
2. Inherit from `BasePage`

```swift
import XCTest

class MyPage: BasePage {
    
    // MARK: - Elements
    
    var myButton: XCUIElement {
        app.buttons[Accessible.MyPage.myButton]
    }
    
    // MARK: - Actions
    
    func tapMyButton() {
        myButton.tap()
    }
    
    // MARK: - Assertions
    
    func verifyMyButtonVisible() {
        XCTAssertTrue(myButton.exists)
    }
}
```

### Run Tests with Verbose Output

```bash
xcodebuild test \
  -scheme SampleApp \
  -verbose \
  -enableCodeCoverage YES
```

### Generate Code Coverage Report

```bash
xcodebuild test \
  -scheme SampleApp \
  -enableCodeCoverage YES \
  -derivedDataPath build

# View coverage in Xcode:
# Xcode → Product → Scheme → Edit Scheme → Test → Options → Code Coverage
```

## Troubleshooting

### Simulator Not Starting

```bash
# Quit simulator
killall "Simulator"

# Start fresh
xcrun simctl erase all
open -a Simulator
```

### Test Timeout Issues

- Increase wait timeouts in `BaseTestCase.swift`
- Check network/performance of your machine
- Ensure simulator has enough resources

### Accessibility Identifier Not Found

```bash
# Debug: Print all elements in view hierarchy
let allElements = app.windows.allElementsBoundByIndex
for element in allElements {
    print(element)
}
```

### App Not Launching in Tests

- Check `LaunchArguments` in `BaseTestCase.setUp()`
- Verify app scheme is set to test target
- Try `xcodebuild clean` then rebuild

## CI/CD Setup

See [docs/CI_CD.md](docs/CI_CD.md) for GitHub Actions workflow configuration.

## Next Steps

1. Read [docs/PAGE_OBJECTS.md](docs/PAGE_OBJECTS.md) for architecture patterns
2. Check [docs/ACCESSIBILITY.md](docs/ACCESSIBILITY.md) for a11y best practices
3. Review [docs/ASYNC_HANDLING.md](docs/ASYNC_HANDLING.md) for wait strategies
4. Explore `SampleAppUITests/` tests to understand patterns

Happy testing! 🎉
