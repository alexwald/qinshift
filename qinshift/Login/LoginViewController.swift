import UIKit

class LoginViewController: UIViewController {
    let instructionLabel = UILabel(frame: .zero)
    let usernameTextField = BaseTextFieldWithError(frame: .zero)
    let passwordTextField = SecureTextFieldWithError(frame: .zero)
    let activityIndicator = UIActivityIndicatorView(frame: .zero)
    let loginButton = RoundedButton(frame: .zero)

    let dependencies: Dependencies

    lazy var controller: LoginController = {
        LoginController(dependencies: dependencies)
    }()
    
    var isLoading: Bool = false {
        didSet {
            if isLoading {
                activityIndicator.startAnimating()
                loginButton.isEnabled = false
            } else {
                activityIndicator.stopAnimating()
                loginButton.isEnabled = areInputsValid()
            }
            usernameTextField.isEnabled = !isLoading
            passwordTextField.isEnabled = !isLoading
        }
    }
    
    // MARK: - Init
    static func instantiate(with dependencies: Dependencies) -> Self {
        return self.init(dependencies: dependencies)
    }

    required init(dependencies: Dependencies) {
        self.dependencies = dependencies
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        usernameTextField.textField.text = nil
        passwordTextField.textField.text = nil
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    // MARK: - Keyboard management
    @objc func hideKeyboard() {
        view.endEditing(true)
        if isUserNameValid() {
            usernameTextField.configure(error: nil)
        }

        if isPasswordValid() {
            passwordTextField.configure(error: nil)
        }

        self.loginButton.isEnabled = self.areInputsValid()
    }
    
    // MARK: - setup views
    func configureViews() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(Self.hideKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        view.backgroundColor = UIColor(named: "AWSessionBackground")
        instructionLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(instructionLabel)
        view.addSubview(usernameTextField)
        view.addSubview(passwordTextField)
        view.addSubview(activityIndicator)
        view.addSubview(loginButton)
        
        instructionLabel.text = NSLocalizedString("Log in with username and password", comment: "login instruction label")
        instructionLabel.numberOfLines = 3
        instructionLabel.font = (UIFont(name: "Helvetica Neue", size: 40))
        instructionLabel.textColor = UIColor(named: "AWLabelColor") ?? .blue
        instructionLabel.textAlignment = .left
        
        usernameTextField.placeholder = NSLocalizedString("Username", comment: "username placeholder")
        usernameTextField.autocorrectionType = .no
        usernameTextField.autocapitalizationType = .none
        usernameTextField.returnKeyType = .next
        usernameTextField.delegate = self
        
        passwordTextField.placeholder = NSLocalizedString("Password", comment: "password placeholder")
        passwordTextField.autocorrectionType = .no
        passwordTextField.autocapitalizationType = .none
        passwordTextField.returnKeyType = .next
        passwordTextField.delegate = self

        loginButton.isEnabled = false
        loginButton.cornerRadius = 30
        loginButton.enabledBackgroundColor = UIColor(named: "AWButtonBlue") ?? .blue
        loginButton.disabledBackgroundColor = UIColor(named: "AWButtonGray") ?? .gray
        loginButton.setTitle(NSLocalizedString("LOG IN", comment: "").uppercased(), for: [])
        loginButton.setTitleColor(.white, for: [])
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            instructionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            instructionLabel.heightAnchor.constraint(equalToConstant: 200),
            instructionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            instructionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: +15),
            instructionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            
            usernameTextField.topAnchor.constraint(equalTo: instructionLabel.bottomAnchor, constant: 15),
            usernameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            usernameTextField.heightAnchor.constraint(greaterThanOrEqualToConstant: 60),
            usernameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: +15),
            usernameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            
            passwordTextField.topAnchor.constraint(equalTo: usernameTextField.topAnchor, constant: 90),
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.heightAnchor.constraint(greaterThanOrEqualToConstant: 60),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: +15),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            
            activityIndicator.heightAnchor.constraint(equalToConstant: 60),
            activityIndicator.widthAnchor.constraint(equalToConstant: 60),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 15),

            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: +15),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            loginButton.heightAnchor.constraint(equalToConstant: 60),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -58)
        ])
    }
    
    // MARK: - IBActions
    @objc func loginButtonTapped() {
        guard let username = usernameTextField.text, let password = passwordTextField.text, areInputsValid() else { return }
        isLoading = true
        
        Task {
            do {
                let model = try await self.controller.loginAccount(userName: username, password: password)
                self.controller.persistLoggedInAccount(username: username, avatar: model.image)
                self.handleLoginSuccess(with: username, avatarImage: model.image)
                self.isLoading = false
            } catch {
                self.handleLoginFailure(error: error)
                self.isLoading = false
            }
        }
    }
    
    func handleLoginSuccess(with username: String, avatarImage: String) {
        let detailVC = DetailViewController(dependencies: dependencies, viewModel: UserViewModel(username: username, avatarImage: avatarImage))
        show(detailVC, sender: self)
    }
    
    func handleLoginFailure(error: Error) {
        let alert = UIAlertController(title: NSLocalizedString("Error", comment: "error alert title"), message: NSLocalizedString("failed to log in.", comment: "error message"), preferredStyle: .alert)
        let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: "cancel"), style: .destructive)
        let retry = UIAlertAction(title: NSLocalizedString("Retry", comment: "retry"), style: .default) { action in
            self.loginButtonTapped()
        }
        
        alert.addAction(cancel)
        alert.addAction(retry)
        self.present(alert, animated: true)
    }
}

// MARK: - Validation helpers
extension LoginViewController {
    func isUserNameValid() -> Bool {
        return controller.isUserNameValid(usernameTextField.text)
    }

    func isPasswordValid() -> Bool {
        return controller.isPasswordValid(passwordTextField.text)
    }

    func areInputsValid() -> Bool {
        return controller.areInputsValid(username: usernameTextField.text, password: passwordTextField.text)
    }
}

// MARK: - Textfields
extension LoginViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let textField = textField as? BaseTextField else { return }
        textField.inputIsValid = true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case usernameTextField.textField where !isUserNameValid():
            usernameTextField.configure(error: LoginParametersError.valueInvalid)
        case passwordTextField.textField where !isPasswordValid():
            passwordTextField.configure(error: LoginParametersError.valueInvalid)
        default:
            break
        }
        self.loginButton.isEnabled = self.areInputsValid()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case usernameTextField.textField:
            passwordTextField.textField.becomeFirstResponder()
        case passwordTextField.textField:
            hideKeyboard()
        default:
            break
        }

        if isUserNameValid() { usernameTextField.configure(error: nil) }
        if isPasswordValid() { passwordTextField.configure(error: nil) }

        return true
    }

    @objc func textFieldValueChanged() {
        self.loginButton.isEnabled = areInputsValid()
    }
}
