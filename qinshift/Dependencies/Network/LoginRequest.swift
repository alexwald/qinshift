import Foundation

struct LoginRequest: CodableAPIRequest {
    typealias Response = LoginResponseModel
    
    var path: String { return "download/bootcamp/image.php" }
    var httpMethod: HTTPMethod { return .POST }
    
    // Parameters
    let userName: String
    
    private enum CodingKeys: String, CodingKey {
        case userName = "username"
    }

    init(userName: String) {
        self.userName = userName
    }
}
