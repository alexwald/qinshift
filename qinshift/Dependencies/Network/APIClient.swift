import Foundation

protocol APIClient {

    var session: URLSession { get }
    var host: String { get }

    // JSON decoder to decode responses
    var jsonDecoder: JSONDecoder { get }
    // URL Form to encode requests
    var urlFormEncoder: URLEncodedFormEncoder { get }

    // URL request creation and sending
    func send<T: DecodableAPIRequest>(_ request: T, authentication: Authentication) async throws -> T.Response

    // Handling response
    func handle<T: Decodable>(response: (data: Data, response: URLResponse), for request: URLRequest) throws -> T
    func handle(errorResponse: (data: Data, response: URLResponse), for request: URLRequest) -> Error
}

extension APIClient {

    func send<T: DecodableAPIRequest>(_ request: T, authentication: Authentication = .none) async throws -> T.Response {
        return try await composeAndSend(request: request, authentication: authentication)
    }

    func composeAndSend<T: DecodableAPIRequest>(request: T, authentication: Authentication = .none) async throws -> T.Response {

        guard AWSDKReachability.isConnectedToNetwork() else {
            throw APIClientError(code: .notConnectedToInternet)
        }

        let urlRequest: URLRequest

        switch request {
        case let encodableRequest as EncodableAPIRequest:
            // Encode parameters as JSON into httpBody if EncodableAPIRequest
            urlRequest = try encodableRequest.urlRequest(with: host, encoder: urlFormEncoder, authentication: authentication)
        default:
            urlRequest = try request.urlRequest(with: host, authentication: authentication)
        }

        let response = try await session.data(for: urlRequest)
        return try handle(response: response, for: urlRequest)
    }
}

// MARK: - Response handling
extension APIClient {

    func handle<T: Decodable>(response: (data: Data, response: URLResponse), for request: URLRequest) throws -> T {
        // Create response string
        let responseString = String(data: response.data, encoding: .utf8)

        // Check if we got HTTP response
        guard let httpResponse = response.response as? HTTPURLResponse else {
            let error = APIClientError(
                code: .invalidResponse,
                request: request,
                response: responseString
            )
            print(error.localizedDescription)
            throw error
        }

        // Check HTTP status code and map to error or decode JSON
        let statusCode = httpResponse.statusCode
        switch statusCode {
        case 200...299:
        do {
            let object = try jsonDecoder.decode(T.self, from: response.data)
            return object
        } catch let error {
                // Handle JSON decoding error
                let error = APIClientError(
                    code: .jsonDecoding,
                    request: request,
                    response: responseString,
                    responseStatusCode: statusCode,
                    error: error
                )
                print(error.localizedDescription)
                throw error
            }
        default:
            let error = handle(errorResponse: response, for: request)
            print(error.localizedDescription)
            throw error
        }
    }

    func handle(errorResponse: (data: Data, response: URLResponse), for request: URLRequest) -> Error {
        // Create response string
        let responseString = String(data: errorResponse.data, encoding: .utf8)

        // Check if we got HTTP response
        guard let httpResponse = errorResponse.response as? HTTPURLResponse else {
            return APIClientError(
                code: .invalidResponse,
                request: request,
                response: responseString
            )
        }

        let statusCode = httpResponse.statusCode
        
        // basic error handling for wrong username / password
        return APIClientError(
            code: statusCode == 401 ? .unathorized : .unknown ,
            request: request,
            response: responseString,
            responseStatusCode: statusCode
        )
    }
}
