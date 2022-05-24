import Foundation

public protocol URLSessionDataTaskable {
    func resume()
    func cancel()
}

extension URLSessionDataTask: URLSessionDataTaskable {}
