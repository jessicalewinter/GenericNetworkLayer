import Foundation

public protocol RequestBuilding {
    
}

final class RequestBuilder: RequestBuilding {
    private let endpoint: Endpoint
    
    public init(endpoint: Endpoint) {
        self.endpoint = endpoint
    }
}
