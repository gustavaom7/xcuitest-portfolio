# iOS Accessibility Best Practices for Testing

## Why Accessibility Matters

1. **For Users**: ~15-20% of users benefit from accessibility features
2. **For Testing**: Accessibility identifiers make tests more robust
3. **For Business**: Accessible apps reach wider audiences

## XCUITest & Accessibility

XCUITest relies on **VoiceOver accessibility tree** to find elements. Elements without proper accessibility setup are:
- Hard to find in tests
- Fragile (position/text-dependent)
- Inaccessible to real users

## Setting Up Accessibility in Your App

### 1. Accessibility Identifiers

Every testable element needs an **accessibilityIdentifier** in the app:

```swift
// Swift/UIKit
import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set accessibility identifiers
        emailTextField.accessibilityIdentifier = "loginEmailTextField"
        loginButton.accessibilityIdentifier = "loginSubmitButton"
    }
}
```

### 2. Accessibility Labels

Provide descriptive labels for screen readers:

```swift
// UIButton
loginButton.accessibilityLabel = "Log in"
loginButton.accessibilityHint = "Double tap to log in with your credentials"

// UITextField
emailTextField.accessibilityLabel = "Email Address"
emailTextField.accessibilityHint = "Enter your email address"

// UIImageView
profileImageView.accessibilityLabel = "User Profile Picture"
```

### 3. Custom Controls

For custom components, implement accessibility:

```swift
class CustomRatingControl: UIView {
    override var accessibilityLabel: String? {
        get { "Rating: \(currentRating) out of 5 stars" }
        set {}
    }
    
    override var accessibilityHint: String? {
        get { "Tap and drag to set rating" }
        set {}
    }
}
```

### 4. Container Elements

Mark logical groupings as accessibility containers:

```swift
// Group form fields
let formContainer = UIView()
formContainer.accessibilityElements = [emailField, passwordField, loginButton]
formContainer.shouldGroupAccessibilityElements = true
```

### 5. Dynamic Elements

For elements added/removed at runtime:

```swift
// Announce when new content appears
UIAccessibility.post(notification: .announcement, argument: "Login failed, please try again")

// Update existing element
loadingSpinner.accessibilityLabel = "Loading, please wait"
```

## Testing Accessibility

### 1. Verify Elements Are Accessible

```swift
func testLoginPageAccessibility() {
    let emailField = app.textFields[Accessible.Login.emailField]
    
    // Element must exist and be hittable
    XCTAssertTrue(emailField.exists)
    XCTAssertTrue(emailField.isHittable)
    
    // Should have meaningful label
    XCTAssertFalse(emailField.label.isEmpty)
}
```

### 2. Test VoiceOver Compatibility

```swift
func testVoiceOverNavigation() {
    // Verify elements are accessible in tab order
    let emailField = app.textFields[Accessible.Login.emailField]
    let passwordField = app.secureTextFields[Accessible.Login.passwordField]
    let loginButton = app.buttons[Accessible.Login.loginButton]
    
    XCTAssertTrue(emailField.isHittable)
    XCTAssertTrue(passwordField.isHittable)
    XCTAssertTrue(loginButton.isHittable)
}
```

### 3. Check Label Content

```swift
func testAccessibilityLabels() {
    let label = app.staticTexts["homeWelcomeLabel"]
    
    XCTAssertFalse(label.label.isEmpty, "Label should have text")
    XCTAssertTrue(label.label.contains("Welcome"), "Label should say Welcome")
}
```

## Accessibility Identifiers in This Project

All identifiers are centralized in `Accessible.swift`:

```swift
struct Accessible {
    struct Login {
        static let emailField = "loginEmailTextField"
        static let passwordField = "loginPasswordTextField"
        static let loginButton = "loginSubmitButton"
        static let errorMessage = "loginErrorMessage"
    }
    
    struct Home {
        static let welcomeLabel = "homeWelcomeLabel"
        static let userNameLabel = "homeUserNameLabel"
        static let logoutButton = "homeLogoutButton"
    }
}
```

**Naming Convention**: `[Screen][ElementType][ElementName]`

Example:
- `loginEmailTextField` → Login screen, text field, email
- `homeWelcomeLabel` → Home screen, label, welcome
- `settingsDarkModeSwitch` → Settings screen, switch, dark mode

## Common Accessibility Issues

### Issue 1: Element Not Found in Tests

```swift
// ❌ Element has no identifier
let emailField = UITextField()
// emailField.accessibilityIdentifier = "..." // forgot this

// ✅ Always set identifier
emailField.accessibilityIdentifier = "loginEmailTextField"
```

### Issue 2: Custom Views Not Accessible

```swift
// ❌ Custom view with no accessibility support
class CustomButton: UIView {
    // No accessibility setup
}

// ✅ Custom view with accessibility
class CustomButton: UIView {
    override var accessibilityLabel: String? {
        get { "Custom Button" }
        set {}
    }
    
    override var accessibilityTraits: UIAccessibilityTraits {
        get { .button }
        set {}
    }
}
```

### Issue 3: Hidden Elements

```swift
// Elements that are hidden shouldn't be hittable
imageView.isHidden = true
// XCUITest will skip this element

// For deliberately hidden but accessible elements:
imageView.isHidden = true
imageView.accessibilityElementsHidden = false
imageView.isAccessibilityElement = true
```

### Issue 4: Dynamic Content

```swift
// Update accessibility when content changes
dataLabel.text = "Updated at \(Date())"
dataLabel.accessibilityLabel = "Updated at \(formattedDate)"
// Announce to VoiceOver users
UIAccessibility.post(notification: .announcement, argument: "Data updated")
```

## Debugging Accessibility

### In Xcode

1. Run app in simulator
2. Xcode → Debug → View Hierarchy
3. Check Accessibility Inspector:
   - Xcode → Open Developer Tool → Accessibility Inspector
   - Hover over elements to see their accessibility properties

### In Code

```swift
// Print all accessible elements
func printAccessibilityTree(_ element: XCUIElement, indent: String = "") {
    print("\(indent)\(element.elementType.rawValue): \(element.label)")
    for child in element.children {
        printAccessibilityTree(child, indent: indent + "  ")
    }
}

// Usage in test
printAccessibilityTree(app.windows.firstMatch)
```

### Using XCUITest Queries

```swift
// Find elements by type
let allButtons = app.buttons
let allTextFields = app.textFields
let allStaticTexts = app.staticTexts

// Find by partial label
let welcomeElements = app.staticTexts.matching(NSPredicate(
    format: "label CONTAINS 'Welcome'"
))
```

## Testing Strategy

### Level 1: Element Visibility (Basic)

```swift
func testElementsAccessible() {
    XCTAssertTrue(emailTextField.exists)
    XCTAssertTrue(loginButton.exists)
}
```

### Level 2: Interaction (Intermediate)

```swift
func testElementsInteractable() {
    XCTAssertTrue(emailTextField.isHittable)
    emailTextField.tap()
    emailTextField.typeText("test@example.com")
}
```

### Level 3: VoiceOver (Advanced)

```swift
func testVoiceOverCompatibility() {
    // Verify logical tab order
    let firstElement = emailTextField
    XCTAssertTrue(firstElement.isHittable)
    
    // Test keyboard navigation
    // (Requires special handling in XCUITest)
}
```

## Resources

- [Apple Accessibility Documentation](https://developer.apple.com/accessibility/)
- [UIAccessibility Framework](https://developer.apple.com/documentation/uikit/uiaccessibility)
- [XCUITest & Accessibility](https://developer.apple.com/documentation/xctest/accessing_xc_ui_elements)

## Best Practices Summary

| Practice | Why | Example |
|----------|-----|---------|
| Always set `accessibilityIdentifier` | Robust element finding | `emailField.accessibilityIdentifier = "loginEmailTextField"` |
| Use descriptive `accessibilityLabel` | Helps VoiceOver users | `"Email Address"` not `"field1"` |
| Group related elements | Logical navigation | `shouldGroupAccessibilityElements = true` |
| Announce dynamic changes | Inform users of updates | `UIAccessibility.post(notification: .announcement, ...)` |
| Test on real devices | Simulator a11y may differ | Run tests on iPhone 14/15 |

By combining XCUITest with proper accessibility setup, you create tests that both validate functionality **and** ensure your app is usable for everyone.
