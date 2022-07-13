import Foundation
import Combine

public protocol URLSessionable {
    func dataTask(request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskable
}

extension URLSession: URLSessionable {
    public func dataTask(request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskable {
        return dataTask(with: request, completionHandler: completionHandler)
    }
}
