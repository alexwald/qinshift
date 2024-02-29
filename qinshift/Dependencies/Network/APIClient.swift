import Foundation

protocol APIClient {

    var session: URLSession { get }
    var host: String { get }

    // JSON decoder to decode responses
    var jsonDecoder: JSONDecoder { get }
    // JSON Encoder to encode requests
    var jsonEncoder: JSONEncoder { get }

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
            urlRequest = try encodableRequest.urlRequest(with: host, encoder: jsonEncoder, authentication: authentication)
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
            // In case of no response, create an empty JSON and try to parse
//            guard let data = response.data else {
//                let error = APIClientError(
//                    code: .noData,
//                    request: request,
//                    response: responseString,
//                    responseStatusCode: statusCode
//                )
//                print(error.localizedDescription)
//                throw error
//            }

            do {
                // Try to decode response first
                
//                let object = try jsonDecoder.decode(APIResponseModel<T>.self, from: data)
                let object = try jsonDecoder.decode(T.self, from: response.data)

//                return object.data
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
        // Try to decode errors returned from BE
        guard let errorModel = try? jsonDecoder.decode(APIResponseErrorModel.self, from: errorResponse.data) else {
            // Handle no error data
            return APIClientError(
                code: .noData,
                request: request,
                response: responseString,
                responseStatusCode: statusCode
            )
        }

        let error = APIResponseError(
            model: errorModel,
            request: request,
            response: responseString,
            responseStatusCode: statusCode
        )
        return error
    }
}
