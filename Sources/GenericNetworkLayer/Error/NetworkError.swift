import Foundation

public protocol AutoEquatable: Equatable { }

public extension AutoEquatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        var lhsDump = String()
        dump(lhs, to: &lhsDump)

        var rhsDump = String()
        dump(rhs, to: &rhsDump)

        return rhsDump == lhsDump
    }
}

/// Map all network possible errors
public enum NetworkError: Error, AutoEquatable {
    /// Could not stablish a connection
    case connectionFailure
    
    /// Could not convert data to an UIImage
    case convertDataToImageFailed(Data)

    /// Client Error with statusCode between 400 and 500
    case clientError(_ statusCode: Int, _ dataResponse: String? = nil)
    
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
    case serverError(_ statusCode: Int, _ dataResponse: String? = nil, _ retryAfter: String? = nil)
    
    /// Server-side validation error
    case validationError(String)
    
    /// Indicates an error on the transport layer, e.g. not being able to connect to the server
    case transportError(Error)
        
    /// Indicates a general error
    case unknown(Error)

    /// Untreated status code
    case untreatedCode(Int)

    /// App needs to upgrade
    case upgradeRequired
    
    enum Internal {
        case unavailable
    }
}

// MARK: LocalizedError
extension NetworkError: LocalizedError {
    
    public var errorDescription: String? {
        switch self {
        case .connectionFailure:
            return Strings.NetworkError.connectionFailure
        case .convertDataToImageFailed(let data):
            return Strings.NetworkError.convertDataToImageFailed(data)
        case let .clientError(statusCode, dataResponse):
            return Strings.NetworkError.clientError(statusCode, dataResponse ?? "Empty data")
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
            let data = dataResponse ?? "Empty data"
            let retryAfter = retryAfter ?? "No retry after provided"
            return Strings.NetworkError.serverError(statusCode, data, retryAfter)
        case .validationError(let message):
            return Strings.NetworkError.validationError(message)
        case .transportError(let error):
            return Strings.NetworkError.transportError(error.localizedDescription)
        case .unknown(let error):
            return Strings.NetworkError.unknown(error.localizedDescription)
        case .untreatedCode(let statusCode):
            return Strings.NetworkError.untreatedCode(statusCode)
        case .upgradeRequired:
            return Strings.NetworkError.upgradeRequired
        }
    }
}

// MARK: CaseIterable
extension NetworkError: CaseIterable {
    private static var errorMock: Error {
        NSError(domain: "mock", code: 1)
    }
    
    private static var serverErrorMock: (statusCode: Int, String, String) {
        return (200, "mock", "yes")
    }
    
    public static var allCases: [NetworkError] {
        return [
            .connectionFailure,
            .clientError(200, "mock"),
            .decodeFailure(NetworkError.errorMock),
            .encodeFailure(NetworkError.errorMock),
            .invalidDataToStringCast,
            .invalidURLResponseToHTTPResponseCast,
            .invalidURL(url: "mock"),
            .noData,
            .serverError(serverErrorMock.0, serverErrorMock.1, serverErrorMock.2),
            .validationError("mock"),
            .transportError(NetworkError.errorMock),
            .upgradeRequired,
            .unknown(errorMock)
        ]
    }
}
