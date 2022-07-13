import Foundation

public enum ContentType {
    case applicationAtomXml
    case applicationFormUrlEncoded
    case applicationJson
    case applicationOctetStream
    case applicationSvgXml
    case applicationXhtmlXml
    case applicationXml
    case multipartFormData(boundary: String? = nil)
    case textHtml
    case textPlain
    case textXml
    case wildcard

    public var value: String {
        switch self {
        case .applicationAtomXml:
            return "application/atom+xml"
        case .applicationFormUrlEncoded:
            return "application/x-www-form-urlencoded"
        case .applicationJson:
            return "application/json"
        case .applicationOctetStream:
            return "application/octet-stream"
        case .applicationSvgXml:
            return "application/svg+xml"
        case .applicationXhtmlXml:
            return "application/xhtml+xml"
        case .applicationXml:
            return "application/xml"
        case .multipartFormData(boundary: let boundary):
            guard let boundary = boundary else {
                return "multipart/form-data"
            }
            return "multipart/form-data; boundary=\(boundary)"
        case .textHtml:
            return "text/html"
        case .textPlain:
            return "text/plain"
        case .textXml:
            return "text/xml"
        case .wildcard:
            return "*/*"
        }
    }
}
