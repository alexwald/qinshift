import Foundation

class LoginController {
    let dependencies: Dependencies

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
}

// MARK: - Validation
// TODO: define username and password constraints

extension LoginController {
    func areInputsValid(username: String?, password: String?) -> Bool {
        return isUserNameValid(username) && isPasswordValid(password)
    }

    func isUserNameValid(_ username: String?) -> Bool {
        return username?.isEmpty == false
    }

    func isPasswordValid(_ password: String?) -> Bool {
        return password?.isEmpty == false
    }
}

// MARK: - Account login
extension LoginController {
    func loginAccount(userName: String, password: String) async throws -> LoginResponseModel {
        return try await dependencies.loginClient.login(userName: userName, password: password)
    }
    
    func persistLoggedInAccount(username: String, avatar: String) {
        dependencies.storageController[.userName] = username
        dependencies.storageController[.avatarImage] = avatar
    }
}
