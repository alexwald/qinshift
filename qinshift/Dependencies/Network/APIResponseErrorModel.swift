import Foundation

// MARK: - Error Response from BE
public struct APIResponseErrorModel: Decodable {
    let id: String
    let apiVersion: String
    let error: APIResponseErrorDataModel
}

public struct APIResponseErrorDataModel: Decodable {
    let code: APIResponseErrorCode
    let message: String
}

// MARK: - API Error codes
public enum APIResponseErrorCode: String, APIErrorCodeProtocol {
    // HTTP errors
    case notFound = "NOT_FOUND"
    case badRequest = "BAD_REQUEST"
    case unauthenticated = "CLIENT_NOT_AUTHENTICATED"
    case unauthorized = "CLIENT_NOT_AUTHORIZED"
    case serverError = "SERVER_ERROR"
    // User errors
    case userInactive = "USER_ACCOUNT_INACTIVE"
    case userConsentMissing = "USER_CONSENT_MISSING"
    // Auth errors
    case authSessionInactive = "AUTH_SESSION_INACTIVE"
    case authSessionNotPresent = "AUTH_SESSION_NOT_PRESENT"
    case authJwtVerificationFailure = "AUTH_JWT_VERIFY_FAILED"
    // Verification token errors
    case jwtMalformed = "AUTH_JWT_MALFORMED"
    case jwtTokenExpired = "AUTH_JWT_TOKEN_EXPIRED"
    case jwtMissing = "AUTH_JWT_NO_AUTHORIZATION_IN_HEADER"
    case jwtInvalid = "AUTH_JWT_TOKEN_INVALID"
    // Vendor errors
    case emailSendFailure = "EMAIL_SEND_FAILURE"
    case testMessageSendFailure = "MESSAGE_SEND_FAILURE"
    case notificationSendFailure = "PUSH_NOTIFICATION_SEND_FAILURE"
    // Google cloud errors
    case googleSignUrlFailure = "SIGN_URL_FAILURE"
    // Validation errors
    case badIanaTimeZone = "BAD_IANA_TIMEZONE"
    // Other errors
    case unspecified = "UNSPECIFIED_ERROR"
    case errorHandlerInternalFailure = "ERROR_HANDLER_FAILURE"
    case errorHandlerCalledWithoutError = "ERROR_HANDLER_NO_ERROR"

    public init(from decoder: Decoder) throws {
        self = try APIResponseErrorCode(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unspecified
    }

    public var codeIndex: Int {
        return Self.allCases.firstIndex(of: self) ?? 0
    }
}
