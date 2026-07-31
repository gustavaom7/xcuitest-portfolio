import Foundation

struct TestData {

    struct ValidCredentials {
        static let email = "test@example.com"
        static let password = "Password123!"
        static let userName = "Test User"
    }

    struct InvalidCredentials {
        static let wrongPassword = "WrongPassword123!"
        static let nonExistentEmail = "nonexistent@example.com"
        static let emptyEmail = ""
        static let emptyPassword = ""
    }

    struct EdgeCases {
        static let veryLongEmail = "test+very.long.email.address.that.tests.input.limits@example.com"
        static let veryLongPassword = String(repeating: "A", count: 100)
        static let specialCharPassword = "P@$$w0rd!#%&*()[]{}|"
        static let spaceInEmail = "test @example.com"
        static let sqlInjectionAttempt = "'; DROP TABLE users; --"
    }

    struct ErrorMessages {
        static let invalidCredentials = "Invalid email or password"
        static let emailRequired = "Email is required"
        static let passwordRequired = "Password is required"
        static let invalidEmailFormat = "Invalid email format"
        static let networkError = "Network connection failed"
    }
}
