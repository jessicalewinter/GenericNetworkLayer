
import Foundation

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}


public struct HTTPMethod2: Hashable {
    public static let get = HTTPMethod2(rawValue: "GET")
    public static let post = HTTPMethod2(rawValue: "POST")
    public static let put = HTTPMethod2(rawValue: "PUT")
    public static let patch = HTTPMethod2(rawValue: "PATCH")
    public static let delete = HTTPMethod2(rawValue: "DELETE")
    
    public let rawValue: String
}
