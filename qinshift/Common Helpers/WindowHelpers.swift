import UIKit

class WindowHelpers {
    static func setRootViewController(_ vc: UIViewController) {
            if let windowScene = UIApplication.shared.connectedScenes
                .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                let navigationVC = UINavigationController(rootViewController: vc)
                windowScene.windows.first?.rootViewController = navigationVC
            }
    }

    static func logoutUser(dependencies: Dependencies) {
        dependencies.storageController.removeAll()
        
        if let windowScene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            
            if let navigationVC = windowScene.windows.first?.rootViewController as? UINavigationController {
                if let _ = navigationVC.viewControllers.last(where: { $0.isKind(of: LoginController.self) }) {
                    navigationVC.popToRootViewController(animated: true)
                } else {
                    let loginVC = LoginViewController(dependencies: dependencies)
                    navigationVC.viewControllers.insert(loginVC, at: 0)
                    navigationVC.popToRootViewController(animated: true)
                }
            } else {
                let loginVC = LoginViewController(dependencies: dependencies)
                let navigationVC = UINavigationController(rootViewController: loginVC)
                windowScene.windows.first?.rootViewController = navigationVC
            }
        }
    }
    
    static func designatedFirstViewController(dependencies: Dependencies) -> UIViewController {
        guard let userName = dependencies.storageController[.userName], 
                let avatar = dependencies.storageController[.avatarImage]
        else {
            return LoginViewController(dependencies: dependencies)
        }

        return DetailViewController(dependencies: dependencies, viewModel: UserViewModel(username: userName, avatarImage: avatar))
    }
}
