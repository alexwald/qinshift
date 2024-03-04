import Foundation

public enum HTTPHeaderField: String {
    case contentType = "Content-Type"
    case authorization = "authorization"
}

public enum ContentType: String {
    case json = "application/json"
    case urlencoded = "application/x-www-form-urlencoded"
    case multipart = "multipart/form-data; boundary="
    // case ...
}

public enum HTTPMethod: String {
    case GET
    case POST
    case PUT
    case PATCH
    case DELETE
    case OPTIONS
}

public extension URLRequest {
    // MARK: - Generic function

    mutating func setValue(_ value: String?, forHTTPHeaderField field: HTTPHeaderField) {
        self.setValue(value, forHTTPHeaderField: field.rawValue)
    }

    mutating func setValues(for fields: [HTTPHeaderField: String?]) {
        fields.forEach { (element) in
            setValue(element.value, forHTTPHeaderField: element.key)
        }
    }

    mutating func setHTTPMethod(_ method: HTTPMethod) {
        self.httpMethod = method.rawValue
    }

    // MARK: - Specific usage

    mutating func setJSONContentType() {
        setValue(ContentType.json.rawValue, forHTTPHeaderField: .contentType)
    }
    
    mutating func setUrlEncpodedContentType() {
        setValue(ContentType.urlencoded.rawValue, forHTTPHeaderField: .contentType)
    }

    mutating func setMimeContentType(with contentType: String) {
        setValue(contentType, forHTTPHeaderField: .contentType)
    }

    mutating func setAuthentication(_ authentication: Authentication) {
        self.setValue(authentication.headerValue, forHTTPHeaderField: HTTPHeaderField.authorization)
    }

    mutating func setMultipartContentType(boundary: String) {
        setValue(ContentType.multipart.rawValue + boundary, forHTTPHeaderField: .contentType)
    }

    mutating func setJSONContent<T: Encodable>(_ content: T, encoder: JSONEncoder) throws {
        self.httpBody = try encoder.encode(content)
    }
    
    mutating func setUrlEncodedContent<T: Encodable>(_ content: T, encoder: URLEncodedFormEncoder) throws {
        self.httpBody = try encoder.encode(content)
    }

    // MARK: - Constructing full path
    static func fullPath(with host: String, path: String) -> String {
        var fullPath = host
        if fullPath.hasSuffix("/") == false {
            fullPath.append("/")
        }

        var path = path
        if path.hasPrefix("/") {
            path.removeFirst()
        }
        fullPath.append(path)

        return fullPath
    }

    // MARK: - Work with multipart data
    static func boundaryString(with boundary: String) -> String {
        return "Boundary-\(boundary)"
    }
}
