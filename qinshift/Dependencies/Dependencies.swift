import Foundation

class Dependencies {
    // MARK: - Storage
    public let storageController: StorageController
    
    public var isUserLoggedIn: Bool { return storageController[.userName] != nil ? true : false }

    // MARK: - Networking clients
    public let loginClient: LoginAPIClient
    
    public init(host: String, session: URLSession = .shared) {
        self.storageController = StorageController()
        self.loginClient = LoginAPIClient(host: host, session: session)
    }
}
