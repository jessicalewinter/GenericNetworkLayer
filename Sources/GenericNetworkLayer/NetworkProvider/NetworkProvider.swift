import Foundation

public protocol NetworkProvidable {
    func request<T: Decodable>(endpoint: Endpoint, completion: @escaping (Result<T, NetworkError>) -> Void)
}

public final class NetworkProvider: NetworkProvidable {
    private let session: URLSessionable
    private let globalQueue: Dispatching
    private let decoder: JSONDecodable
    
    public init(
        session: URLSessionable = URLSession.shared,
        globalQueue: Dispatching = DispatchQueue.global(),
        decoder: JSONDecodable = JSONDecoder(.convertFromSnakeCase)
    ) {
        self.session = session
        self.globalQueue = globalQueue
        self.decoder = decoder
    }
    
    public func request<T: Decodable>(endpoint: Endpoint, completion: @escaping (Result<T, NetworkError>) -> Void) {
        
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
                do {
                    let model = try self.decoder.decode(T.self, from: data)
                    completion(.success(model))
                } catch let error {
                    completion(.failure(.decodeFailure(error)))
                }
            case 400...499:
                completion(.failure(.clientError(statusCode, dataString)))
            case 500...599:
                completion(.failure(.serverError(statusCode, dataString)))
            default:
                completion(.failure(.untreatedCode(statusCode)))
            }
        }
        
        globalQueue.async {
            task.resume()
        }
    }
}
