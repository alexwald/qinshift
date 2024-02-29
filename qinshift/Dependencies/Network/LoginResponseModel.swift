import Foundation

struct LoginResponseModel: Decodable {
    let image: String
    
    private enum CodingKeys: String, CodingKey {
        case image
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.image = try container.decode(String.self, forKey: .image)

    }
}
