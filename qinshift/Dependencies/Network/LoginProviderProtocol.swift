import Foundation

protocol LoginProviderProtocol: AnyObject {
    func login(userName: String, password: String) async throws -> LoginResponseModel
}
