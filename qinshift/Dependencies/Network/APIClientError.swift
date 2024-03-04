import Foundation

public struct APIClientError {
    // Code of the error
    public let code: APIClientErrorCode
    // We use request URL for logging purposes
    public let request: URLRequest?
    // We use response string for logging purposes
    public let response: String?
    // We use response status code for logging purposes
    public let responseStatusCode: Int?
    // Possible error (e.g. from JSON decoding)
    public let error: Error?

    public init(
        code: APIClientErrorCode,
        request: URLRequest? = nil,
        response: String? = nil,
        responseStatusCode: Int? = nil,
        error: Error? = nil
    ) {
        self.code = code
        self.request = request
        self.response = response
        self.responseStatusCode = responseStatusCode
        self.error = error
    }
}

// MARK: - Localizing the message for user
extension APIClientError: LocalizedError {
    public var errorDescription: String? {
        var errorMessage = code.rawValue
        if let localizedError = error?.localizedDescription {
            errorMessage += ": \(localizedError)"
        }
        return errorMessage
    }
}

// MARK: - Equatable support
extension APIClientError: Equatable {
    public static func == (lhs: APIClientError, rhs: APIClientError) -> Bool {
        return lhs.code == rhs.code
    }
}


// MARK: - API Client Error codes
public enum APIClientErrorCode: String, APIErrorCodeProtocol {
    case notConnectedToInternet, urlCreating, urlRequestCreating
    case invalidResponse, unknown, jsonDecoding
    case unathorized

    public var codeIndex: Int {
        return Self.allCases.firstIndex(of: self) ?? 0
    }
    
    public var localizedError: String {
        switch self {
        case .notConnectedToInternet:
            return NSLocalizedString("No internet connection", comment: "")
        case .urlCreating:
            return NSLocalizedString("Error creating URL", comment: "")
        case .urlRequestCreating:
            return NSLocalizedString("Error creating URL request", comment: "")
        case .invalidResponse:
            return NSLocalizedString("Invalid response", comment: "")
        case .unknown:
            return NSLocalizedString("Unknown error", comment: "")
        case .jsonDecoding:
            return NSLocalizedString("Error decoding JSON", comment: "")
        case .unathorized:
            return NSLocalizedString("Wrong username or password", comment: "")
        }
    }
}

public protocol APIErrorCodeProtocol: Decodable, CaseIterable {
    var rawValue: String { get }
    var codeIndex: Int { get }
}
