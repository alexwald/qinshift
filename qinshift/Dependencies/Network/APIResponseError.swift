import Foundation

public struct APIResponseError {
    // Code of the error
    public let code: APIResponseErrorCode
    // Message from BE to display to the user
    public let message: String?
    // We use request URL for logging purposes
    public let request: URLRequest?
    // We use response string for logging purposes
    public let response: String?
    // We use response status code for logging purposes
    public let responseStatusCode: Int?
    // Possible error (e.g. from JSON decoding)
    public let error: Error?

    public init(
        model: APIResponseErrorModel,
        request: URLRequest? = nil,
        response: String? = nil,
        responseStatusCode: Int? = nil,
        error: Error? = nil
    ) {
        self.code = model.error.code
        self.message = model.error.message
        self.request = request
        self.response = response
        self.responseStatusCode = responseStatusCode
        self.error = error
    }
}

// MARK: - Localizing the message for user
extension APIResponseError: LocalizedError {
    public var errorDescription: String? {
        return message
    }
}

// MARK: - Equatable support
extension APIResponseError: Equatable {
    public static func == (lhs: APIResponseError, rhs: APIResponseError) -> Bool {
        return lhs.code == rhs.code
    }
}
