import UIKit

class DetailViewController: UIViewController {
    let instructionLabel = UILabel(frame: .zero)
    let roundContainer = UIView(frame: .zero)

    let avatarImage = UIImageView(frame: .zero)
    let logoutButton = RoundedButton(frame: .zero)
    
    let dependencies: Dependencies
    let viewModel: UserViewModel
    
    // MARK: - Init
    static func instantiate(with dependencies: Dependencies, viewModel: UserViewModel) -> Self {
        return self.init(dependencies: dependencies, viewModel: viewModel)
    }

    required init(dependencies: Dependencies, viewModel: UserViewModel) {
        self.dependencies = dependencies
        self.viewModel = viewModel
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
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
     override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
         roundContainer.clipsToBounds = true
         roundContainer.layer.masksToBounds = true
         roundContainer.layer.cornerRadius = roundContainer.frame.width / 2
    }
    
    func configureViews() {
        view.backgroundColor = UIColor(named: "AWSessionBackground")
        instructionLabel.translatesAutoresizingMaskIntoConstraints = false
        roundContainer.translatesAutoresizingMaskIntoConstraints = false
        avatarImage.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(instructionLabel)
        view.addSubview(roundContainer)
        roundContainer.addSubview(avatarImage)
        view.addSubview(logoutButton)

        avatarImage.image = viewModel.avatarImage?.base64ToImage() ?? UIImage(named: "icon-avatar-placeholder")
        avatarImage.contentMode = .scaleAspectFit
        
        roundContainer.layer.borderWidth = 2
        roundContainer.layer.borderColor = UIColor(named: "AWGray")?.cgColor ??  UIColor.gray.cgColor
        
        instructionLabel.text = NSLocalizedString("Welcome, ", comment: "detail screen welcome") + viewModel.username + "."
        instructionLabel.numberOfLines = 2
        instructionLabel.font = (UIFont(name: "Helvetica Neue", size: 20))
        instructionLabel.textColor = UIColor(named: "AWLabelColor") ?? .blue
        instructionLabel.textAlignment = .center
        
        logoutButton.isEnabled = true
        logoutButton.cornerRadius = 30
        logoutButton.enabledBackgroundColor = UIColor(named: "AWButtonBlue") ?? .blue
        logoutButton.disabledBackgroundColor = UIColor(named: "AWButtonGray") ?? .gray
        logoutButton.setTitle(NSLocalizedString("LOG OUT", comment: "").uppercased(), for: [])
        logoutButton.setTitleColor(.white, for: [])
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            roundContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            roundContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            roundContainer.heightAnchor.constraint(equalToConstant: 200),
            roundContainer.widthAnchor.constraint(equalToConstant: 200),
            
            avatarImage.centerXAnchor.constraint(equalTo: roundContainer.centerXAnchor),
            avatarImage.centerYAnchor.constraint(equalTo: roundContainer.centerYAnchor),
            avatarImage.heightAnchor.constraint(equalTo: roundContainer.heightAnchor),
            avatarImage.widthAnchor.constraint(equalTo: roundContainer.widthAnchor),
            
            instructionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            instructionLabel.heightAnchor.constraint(equalToConstant: 80),
            instructionLabel.topAnchor.constraint(equalTo: avatarImage.bottomAnchor, constant: 20),
            instructionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: +15),
            instructionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
  
            logoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: +15),
            logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            logoutButton.heightAnchor.constraint(equalToConstant: 60),
            logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoutButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -58)
        ])
        
        view.layoutIfNeeded()
    }
    
    func setRoundContainerCornerRadius() {
        roundContainer.layoutIfNeeded()
        roundContainer.clipsToBounds = true
        roundContainer.layer.masksToBounds = true
        roundContainer.layer.cornerRadius = roundContainer.frame.width / 2
    }
    
    
    @objc func logoutButtonTapped() {
        let alert = UIAlertController(title: NSLocalizedString("Alert", comment: "alert title"), message: NSLocalizedString("Are you sure you want to log out?", comment: "logout confirmation text"), preferredStyle: .alert)
        let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: "cancel button title"), style: .cancel)
        let logout = UIAlertAction(title: NSLocalizedString("Logout", comment: "logout button title"), style: .destructive) { action in
            WindowHelpers.logoutUser(dependencies: self.dependencies)
        }
        alert.addAction(cancel)
        alert.addAction(logout)
        self.present(alert, animated: true)
    }
}
