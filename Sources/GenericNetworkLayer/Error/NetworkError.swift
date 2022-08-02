import Foundation

/// Map all network possible errors
public enum NetworkError: Error {
    /// Could not stablish a connection
    case connectionFailure
    
    /// Client Error with statusCode between 400 and 500
    case clientError(_ statusCode: Int, _ dataResponse: String)
    
    /// The server sent data in an wrong format
    case decodeFailure(Error)
    
    /// The data encoded is in a wrong format
    case encodeFailure(Error)
    
    /// Could not cast Data type to String
    case invalidDataToStringCast
    
    /// Could not cast URLResponse type to HTTPURLResponse
    case invalidURLResponseToHTTPResponseCast
    
    /// The given URL is in a wrong format
    case invalidURL(url: String)
    
    /// Empty Data
    case noData
    
    /// Server-side Error with statusCode between 500 and 600. If `retryAfter` is set, the client can send the same request after the given time.
    case serverError(_ statusCode: Int, _ dataResponse: String, _ retryAfter: String? = nil)
    
    /// Server-side validation error
    case validationError(String)
    
    /// Indicates an error on the transport layer, e.g. not being able to connect to the server
    case transportError(Error)
    
    /// App needs to upgrade
    case upgradeRequired
    
    /// Indicates an error on the transport layer, e.g. not being able to connect to the server
    case unknown
}

// MARK: LocalizedError
extension NetworkError: LocalizedError {
    
    public var errorDescription: String? {
        switch self {
        case .connectionFailure:
            return Strings.NetworkError.connectionFailure
        case let .clientError(statusCode, dataResponse):
            return Strings.NetworkError.clientError(statusCode, dataResponse)
        case .decodeFailure(let error):
            return Strings.NetworkError.decodeFailure(error.localizedDescription)
        case .encodeFailure(let error):
            return Strings.NetworkError.encodeFailure(error.localizedDescription)
        case .invalidDataToStringCast:
            return Strings.NetworkError.invalidDataToStringCast
        case .invalidURLResponseToHTTPResponseCast:
            return Strings.NetworkError.invalidURLResponseToHTTPResponseCast
        case .invalidURL(let message):
            return Strings.NetworkError.invalidURL(message)
        case .noData:
            return Strings.NetworkError.noData
        case let .serverError(statusCode, dataResponse, retryAfter):
            return Strings.NetworkError.serverError(statusCode, dataResponse, retryAfter ?? "no retry after provided")
        case .validationError(let message):
            return Strings.NetworkError.validationError(message)
        case .transportError(let error):
            return Strings.NetworkError.transportError(error.localizedDescription)
        case .unknown:
            return Strings.NetworkError.unknown
        case .upgradeRequired:
            return Strings.NetworkError.upgradeRequired
        }
    }
}

// MARK: Equatable
extension NetworkError: Equatable {
    public static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        return true
    }
}
