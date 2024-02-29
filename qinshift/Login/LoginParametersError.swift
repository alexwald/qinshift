import Foundation

enum LoginParametersError: String, Error {
    case valueInvalid
}

extension LoginParametersError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .valueInvalid:
            return NSLocalizedString("Value is invalid", comment: "invalid value input error")
        }
    }
}
