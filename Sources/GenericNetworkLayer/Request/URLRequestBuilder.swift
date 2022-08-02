import Foundation

public protocol URLRequestBuilding {
    
}

final class URLRequestBuilder: RequestBuilding {
    private let endpoint: Endpoint
    
    public init(endpoint: Endpoint) {
        self.endpoint = endpoint
    }
    
//    func build() throws ->  URLRequest {
//
//    }
}
