import Foundation

extension URLRequest {
    
    /// A URL request that is builded from the service's specifications
    /// - Parameter service: The object that specify the needed information to make an http request
    
     init(endpoint: Endpoint) {
       if let urlComponents = URLComponents(endpoint: endpoint),
           let url = urlComponents.url {
           self.init(url: url)

           self.httpMethod = endpoint.method.rawValue

           endpoint.headers?.forEach { key, value in
               addValue(value, forHTTPHeaderField: key)
           }

           guard case let .requestWithBody(payload) = endpoint.task else {
                return
           }
                      
           if let payloadEncoded = payload.prepareBody() {
               self.httpBody = payloadEncoded
           }
       } else {
           self.init(url: URL(fileURLWithPath: ""))
       }
   }
}
