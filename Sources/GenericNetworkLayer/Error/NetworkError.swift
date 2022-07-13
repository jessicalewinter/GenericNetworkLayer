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
            return "Could not stablish a connection"
        case let .clientError(statusCode, dataResponse):
            return "Client Error with code \(statusCode).\nData Response: \(dataResponse)"
        case .decodeFailure(let error):
            return "The server returned data in an unexpected format with error: \n\(error.localizedDescription)"
        case .encodeFailure(let error):
            return "Failure to prepare payload to server with error: \n\(error.localizedDescription)"
        case .invalidDataToStringCast:
            return "Could not cast Data type to String"
        case .invalidURLResponseToHTTPResponseCast:
            return "Could not cast URLResponse type to HTTPURLResponse"
        case .invalidURL(let message):
            return "Invalid URL: \(message)"
        case .noData:
            return "The server returned with no data"
        case let .serverError(statusCode, dataResponse, retryAfter):
            return "Server error with code \(statusCode).\nRetry after: \(retryAfter ?? "no retry after provided")\nData Response: \(dataResponse)"
        case .validationError(let message):
            return "Validation Error: \(message)"
        case .transportError(let error):
            return "Transport error: \(error.localizedDescription)"
        case .unknown:
            return "Unknown error"
        case .upgradeRequired:
            return "App needs to update"
        }
    }
}

// MARK: Equatable
extension NetworkError: Equatable {
    public static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        return true
    }
}
