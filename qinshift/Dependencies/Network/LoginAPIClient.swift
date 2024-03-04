import Foundation

public class LoginAPIClient: APIClient, LoginProviderProtocol {
    let session: URLSession
    let host: String
    
    let jsonDecoder: JSONDecoder = JSONDecoder()
    let urlFormEncoder: URLEncodedFormEncoder = URLEncodedFormEncoder()
    
    required init(host: String, session: URLSession) {
        self.host = host
        self.session = session
    }
    
    func login(userName: String, password: String) async throws -> LoginResponseModel {
        let request = LoginRequest(userName: userName)
        return try await send(request, authentication: .password(password: password.sha1()))
    }
}
