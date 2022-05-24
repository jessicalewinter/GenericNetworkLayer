import Foundation

public protocol NetworkProvidable {
    func request<T: Decodable>(type: T.Type, endpoint: EndpointExecutable, completion: @escaping (Result<T, NetworkError>) -> Void)
}

public final class NetworkProvider: NetworkProvidable {
    public var session: URLSessionable
    private let globalQueue: Dispatching
    private let jsonDecodable: JSONDecodable
    
    public init(
        session: URLSessionable = URLSession.shared,
        globalQueue: Dispatching = DispatchQueue.global(),
        jsonDecodable: JSONDecodable = JSONDecoder()
    ) {
        self.session = session
        self.globalQueue = globalQueue
        self.jsonDecodable = jsonDecodable
    }
    
    public func request<T: Decodable>(type: T.Type, endpoint: EndpointExecutable, completion: @escaping (Result<T, NetworkError>) -> Void) {
        
        let request = URLRequest(endpoint: endpoint)
        
        let task = session.dataTask(request: request) { data, response, error in
            if let error = error {
                completion(.failure(.transportError(error)))
            }
            
            guard let data = data else {
                return completion(.failure(.noData))
            }
            
            guard let dataString = String(bytes: data, encoding: .utf8) else {
                return completion(.failure(.invalidDataToStringCast))
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                return completion(.failure(.invalidURLResponseToHTTPResponseCast))
            }
            
            let statusCode = httpResponse.statusCode
            
            switch statusCode {
            case 200...299:
                let decoder = JSONDecoder()
                // Removes the need to use codingkeys on model
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                do {
                    let model = try decoder.decode(T.self, from: data)
                    completion(.success(model))
                } catch let error {
                    completion(.failure(.decodeFailure(error)))
                }
            case 400...499:
                completion(.failure(.clientError(statusCode, dataString)))
            case 500...599:
                completion(.failure(.serverError(statusCode, dataString)))
            default:
                completion(.failure(.unknown))
            }
        }
        
        
        DispatchQueue.global(qos: .userInitiated).async {
            task.resume()
        }
    }
    
    
}
