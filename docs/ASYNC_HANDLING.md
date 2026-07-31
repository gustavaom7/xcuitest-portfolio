# Asynchronous Handling in XCUITest

## The Problem: Timing Issues

iOS apps are inherently asynchronous:
- Network requests take time
- Animations complete at different speeds
- State updates happen on background threads

Without proper synchronization, tests become **flaky**:

```swift
// ❌ Bad: Hard-coded wait (unreliable)
app.buttons["Login"].tap()
Thread.sleep(forTimeInterval: 2.0)  // Always wait 2 seconds?
XCTAssertTrue(app.staticTexts["Welcome"].exists)
// Fails if server is slow, passes if unnecessary delays
```

## The Solution: Smart Waits

### 1. XCUITest Predicates (Recommended)

Wait for specific conditions rather than fixed time:

```swift
// ✅ Good: Wait for element to exist (max 5 seconds)
let predicate = NSPredicate(format: "exists == true")
let expectation = XCTNSPredicateExpectation(predicate: predicate, object: welcomeLabel)

let result = XCTWaiter().wait(for: [expectation], timeout: 5.0)
if result == .completed {
    // Element exists
} else {
    XCTFail("Welcome label did not appear")
}
```

### 2. Element Wait Extensions

Custom extensions for clean, reusable waits:

```swift
// In Utils/XCTestExtensions.swift
extension XCUIElement {
    func waitForExistence(timeout: TimeInterval = 5.0) -> Bool {
        let predicate = NSPredicate(format: "exists == true")
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: self)
        return XCTWaiter().wait(for: [expectation], timeout: timeout) == .completed
    }
}

// Usage
let welcomeLabel = app.staticTexts["homeWelcomeLabel"]
if welcomeLabel.waitForExistence(timeout: 5.0) {
    XCTAssertTrue(true)
}
```

### 3. In Page Objects

```swift
class HomePage: BasePage {
    var welcomeLabel: XCUIElement {
        app.staticTexts["homeWelcomeLabel"]
    }
    
    func verifyHomePageLoaded() {
        wait(for: welcomeLabel, timeout: 5.0)
        XCTAssertTrue(welcomeLabel.exists)
    }
}
```

## Common Async Patterns

### Pattern 1: Network Request

```swift
func testDataLoadsAfterNetworkRequest() {
    // Arrange
    let dataLabel = app.staticTexts["dataLabel"]
    
    // Act - trigger network request
    app.buttons["refreshButton"].tap()
    
    // Assert - wait for data to load
    let predicate = NSPredicate(format: "label CONTAINS 'Loaded'")
    let expectation = XCTNSPredicateExpectation(predicate: predicate, object: dataLabel)
    
    let result = XCTWaiter().wait(for: [expectation], timeout: 10.0)
    XCTAssertEqual(result, .completed)
}
```

### Pattern 2: Animation Completion

```swift
func testElementVisibleAfterAnimation() {
    let animatedView = app.otherElements["animatedView"]
    
    // Wait for animation to finish (element becomes visible)
    XCTAssertTrue(animatedView.waitForExistence(timeout: 2.0))
}
```

### Pattern 3: State Transitions

```swift
func testAppStateChange() {
    // Initial state
    XCTAssertTrue(app.staticTexts["loadingLabel"].exists)
    
    // Wait for state to change
    let predicate = NSPredicate(format: "exists == false")
    let expectation = XCTNSPredicateExpectation(predicate: predicate, 
                                               object: app.staticTexts["loadingLabel"])
    
    let result = XCTWaiter().wait(for: [expectation], timeout: 5.0)
    XCTAssertEqual(result, .completed)
}
```

### Pattern 4: Optional Elements

Some elements appear conditionally (modals, errors):

```swift
extension XCUIElement {
    func tapIfExists() {
        if self.exists && self.isHittable {
            self.tap()
        }
    }
}

// Usage
app.buttons["skipButton"].tapIfExists()  // Dismisses optional modal if present
```

## Advanced Waits

### Multiple Conditions

```swift
func testMultipleConditions() {
    let element1 = app.staticTexts["label1"]
    let element2 = app.buttons["button2"]
    
    let predicate1 = NSPredicate(format: "exists == true")
    let predicate2 = NSPredicate(format: "isHittable == true")
    
    let expectation1 = XCTNSPredicateExpectation(predicate: predicate1, object: element1)
    let expectation2 = XCTNSPredicateExpectation(predicate: predicate2, object: element2)
    
    let result = XCTWaiter().wait(for: [expectation1, expectation2], 
                                  timeout: 5.0,
                                  enforceOrder: false)  // Both must complete
    
    XCTAssertEqual(result, .completed)
}
```

### Custom Predicates

```swift
func testWithCustomPredicate() {
    let textField = app.textFields["emailField"]
    
    // Wait for text to be exactly "test@example.com"
    let predicate = NSPredicate(format: "value LIKE 'test@example.com'")
    let expectation = XCTNSPredicateExpectation(predicate: predicate, object: textField)
    
    textField.tap()
    textField.typeText("test@example.com")
    
    let result = XCTWaiter().wait(for: [expectation], timeout: 3.0)
    XCTAssertEqual(result, .completed)
}
```

## Timeout Best Practices

| Scenario | Recommended Timeout |
|----------|---------------------|
| UI element appears | 1-3 seconds |
| Animation finishes | 0.5-2 seconds |
| Network request | 5-10 seconds |
| Large data load | 15-30 seconds |

```swift
// Category-specific timeouts
let uiTimeout: TimeInterval = 3.0
let networkTimeout: TimeInterval = 10.0
let dataLoadTimeout: TimeInterval = 30.0

// Usage
wait(for: element, timeout: uiTimeout)
```

## Anti-Patterns

### ❌ Hard-Coded Delays

```swift
// Bad - always wait, even if element is already there
Thread.sleep(forTimeInterval: 2.0)
XCTAssertTrue(element.exists)

// Good - wait only as long as needed
element.waitForExistence(timeout: 2.0)
```

### ❌ Infinite Waits

```swift
// Bad - could hang forever
while !element.exists {
    Thread.sleep(forTimeInterval: 0.1)
}

// Good - timeout prevents hanging
element.waitForExistence(timeout: 5.0)
```

### ❌ Testing the Framework

```swift
// Bad - testing XCUITest, not your app
Thread.sleep(forTimeInterval: 0.1)
XCTAssertTrue(true)

// Good - test actual behavior
element.waitForExistence(timeout: 5.0)
XCTAssertTrue(element.exists)
```

## Debugging Async Issues

### Print element state over time

```swift
func debugElement(_ element: XCUIElement, name: String) {
    for i in 0..<10 {
        print("\(name) - Iteration \(i): exists=\(element.exists), hittable=\(element.isHittable)")
        Thread.sleep(forTimeInterval: 0.2)
    }
}

// Usage
debugElement(app.staticTexts["loginError"], name: "Error label")
```

### Check predicate matching

```swift
let element = app.staticTexts["label"]
let predicate = NSPredicate(format: "label CONTAINS 'Expected'")

print("Element exists: \(element.exists)")
print("Element label: \(element.label)")
print("Predicate matches: \(predicate.evaluate(with: element))")
```

## Summary Table

| Method | Use Case | Reliability |
|--------|----------|-------------|
| `Thread.sleep()` | Never (debugging only) | Very Low |
| `XCTWaiter` + Predicates | UI state changes | High |
| Custom wait extensions | Common patterns | High |
| `element.waitForExistence()` | Element appears | High |
| `tapIfExists()` | Optional elements | High |

## Key Takeaways

1. **Always wait for conditions, not time**
2. **Set appropriate timeouts** (3s for UI, 10s for network)
3. **Use predicates** for flexible, robust waits
4. **Extend XCUIElement** for reusable wait patterns
5. **Test on real devices** (timing differs from simulator)

Proper async handling transforms flaky tests into reliable, maintainable automation.
