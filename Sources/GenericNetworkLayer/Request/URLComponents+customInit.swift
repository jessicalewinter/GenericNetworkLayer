import Foundation

extension URLComponents {
    
    /// Build the URL that conforms to the service that receives as parameter
    /// - Parameter service: The object that specify the information needed to do a request
    
    init?(endpoint: Endpoint) {
        self.init(string: endpoint.baseURL)
        self.path = endpoint.path
        
        guard case let .requestParameters(parameters) = endpoint.task,
            endpoint.parametersEncoding == .url else { return }
        
        queryItems = parameters.map({ (key, value) in
            return URLQueryItem(name: key, value: String(describing: value))
        })
        
        print(self.url ?? "hello")
    }
}
