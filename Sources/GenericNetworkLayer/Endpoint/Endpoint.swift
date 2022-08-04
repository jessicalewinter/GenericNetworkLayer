import Foundation

public typealias Headers = [String: String]

public protocol Endpoint {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var task: Task { get }
    var headers: Headers? { get }
    var parametersEncoding: ParametersEncoding { get }
}

extension Endpoint {
    public static func encodeData(request: Encodable) -> [String: Any] {
        do {
            let jsonData = try request.jsonData(strategy: .convertToSnakeCase)
            let json = try JSONSerialization.jsonObject(with: jsonData)
            guard let dictionary = json as? [String: Any] else {
                return [:]
            }
            return dictionary
        } catch {
            return [:]
        }
    }
}
