import Foundation

public protocol URLRequestBuilding {
    
}

final class URLRequestBuilder: URLRequestBuilding {
    private let endpoint: Endpoint
    
    public init(endpoint: Endpoint) {
        self.endpoint = endpoint
    }
}
