import Foundation

extension URLComponents {
    
    /// Build the URL that conforms to the service that receives as parameter
    /// - Parameter service: The object that specify the information needed to do a request
    
    init?(endpoint: Endpoint) {
        let url = endpoint.baseURL.appendingPathComponent(endpoint.path)
        self.init(url: url, resolvingAgainstBaseURL: false)
        
        guard case let .requestParameters(parameters) = endpoint.task else { return }
        
        queryItems = parameters.map({ (key, value) in
            return URLQueryItem(name: key, value: String(describing: value))
        })
    }
}
