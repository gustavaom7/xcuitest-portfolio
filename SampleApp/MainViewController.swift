import UIKit

class MainViewController: UIViewController {

    let emailTextField = UITextField()
    let passwordTextField = UITextField()
    let loginButton = UIButton(type: .system)
    let welcomeLabel = UILabel()
    let errorLabel = UILabel()
    let logoutButton = UIButton(type: .system)
    let settingsButton = UIButton(type: .system)
    let userNameLabel = UILabel()

    var isLoggedIn = false

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        if isLoggedIn {
            setupHomeScreen()
        } else {
            setupLoginScreen()
        }
    }

    func setupLoginScreen() {
        emailTextField.accessibilityIdentifier = "loginEmailTextField"
        emailTextField.placeholder = "Email"
        emailTextField.borderStyle = .roundedRect
        emailTextField.translatesAutoresizingMaskIntoConstraints = false

        passwordTextField.accessibilityIdentifier = "loginPasswordTextField"
        passwordTextField.placeholder = "Password"
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.isSecureTextEntry = true
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false

        loginButton.accessibilityIdentifier = "loginSubmitButton"
        loginButton.setTitle("Login", for: .normal)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)

        errorLabel.accessibilityIdentifier = "loginErrorMessage"
        errorLabel.textColor = .red
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.isHidden = true

        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addSubview(errorLabel)

        NSLayoutConstraint.activate([
            emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -60),
            emailTextField.widthAnchor.constraint(equalToConstant: 200),
            emailTextField.heightAnchor.constraint(equalToConstant: 40),

            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            passwordTextField.widthAnchor.constraint(equalToConstant: 200),
            passwordTextField.heightAnchor.constraint(equalToConstant: 40),

            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 60),

            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorLabel.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 10),
        ])
    }

    func setupHomeScreen() {
        welcomeLabel.accessibilityIdentifier = "homeWelcomeLabel"
        welcomeLabel.text = "Welcome"
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false

        userNameLabel.accessibilityIdentifier = "homeUserNameLabel"
        userNameLabel.text = "Test User"
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false

        logoutButton.accessibilityIdentifier = "homeLogoutButton"
        logoutButton.setTitle("Logout", for: .normal)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)

        settingsButton.accessibilityIdentifier = "homeSettingsButton"
        settingsButton.setTitle("Settings", for: .normal)
        settingsButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(welcomeLabel)
        view.addSubview(userNameLabel)
        view.addSubview(logoutButton)
        view.addSubview(settingsButton)

        NSLayoutConstraint.activate([
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            welcomeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -60),

            userNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            userNameLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoutButton.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 40),

            settingsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            settingsButton.topAnchor.constraint(equalTo: logoutButton.bottomAnchor, constant: 20),
        ])
    }

    @objc func handleLogin() {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            errorLabel.text = "Email and password required"
            errorLabel.isHidden = false
            return
        }

        if email == "test@example.com" && password == "Password123!" {
            isLoggedIn = true
            view.subviews.forEach { $0.removeFromSuperview() }
            setupHomeScreen()
        } else {
            errorLabel.text = "Invalid email or password"
            errorLabel.isHidden = false
        }
    }

    @objc func handleLogout() {
        isLoggedIn = false
        view.subviews.forEach { $0.removeFromSuperview() }
        setupLoginScreen()
    }
}
