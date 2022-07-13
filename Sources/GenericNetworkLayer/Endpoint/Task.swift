import Foundation

public typealias Parameters = [String: Any]

public enum Task {
    case requestPlain
    case requestParameters(Parameters)
    case requestWithBody(Encodable)
}
