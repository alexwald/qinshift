import Foundation

public struct APIResponseModel<T: Decodable>: Decodable {
    let id: String
    let apiVersion: String
    let data: T
}
