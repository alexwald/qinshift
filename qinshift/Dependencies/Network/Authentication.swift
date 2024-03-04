import Foundation

public enum Authentication {
    case none
    case password(password: String)

    var headerValue: String? {
        switch self {
        case .none:
            return nil
        case .password(let password):
            return "\(password)"
        }
    }
}
