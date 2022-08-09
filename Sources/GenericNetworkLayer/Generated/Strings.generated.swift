import Foundation

// TODO: Add swiftgen plugin or wait for an offical implementation

enum Strings {
    enum NetworkError {
        /// Could not stablish a connection
        static let connectionFailure = Strings.tr("Localizable", "NetworkError.connectionFailure")
        /// Could not convert data to an UIImage: %@
        static func convertDataToImageFailed(_ p1: Data) -> String {
            return Strings.tr("Localizable", "NetworkError.convertDataToImageFailed", p1 as CVarArg)
        }
        /// Client Error with code %@.\nData Response: %@
        static func clientError(_ p1: Int, _ p2: String) -> String {
            return Strings.tr("Localizable", "NetworkError.clientError", p1, p2)
        }
        /// The server returned data in an unexpected format with error: \n%@
        static func decodeFailure(_ p1: String) -> String {
            return Strings.tr("Localizable", "NetworkError.decodeFailure", p1)
        }
        /// Failure to prepare payload to server with error: \n%@
        static func encodeFailure(_ p1: String) -> String {
            return Strings.tr("Localizable", "NetworkError.encodeFailure", p1)
        }
        /// Could not cast Data type to String
        static let invalidDataToStringCast = Strings.tr("Localizable", "NetworkError.invalidDataToStringCast")
        /// Could not cast URLResponse type to HTTPURLResponse";
        static let invalidURLResponseToHTTPResponseCast = Strings.tr("Localizable", "NetworkError.invalidURLResponseToHTTPResponseCast")
        /// Invalid URL: %@
        static func invalidURL(_ p1: String) -> String {
            return Strings.tr("Localizable", "NetworkError.invalidURL", p1)
        }
        /// The server returned with no data
        static let noData = Strings.tr("Localizable", "NetworkError.noData")
        /// Server error with code %@.\nRetry after: %@\nData Response: %@
        static func serverError(_ p1: Int, _ p2: String, _ p3: String) -> String {
            return Strings.tr("Localizable", "NetworkError.serverError", p1, p2, p3)
        }
        /// Validation Error: %@
        static func validationError(_ p1: String) -> String {
            return Strings.tr("Localizable", "NetworkError.validationError", p1)
        }
        /// Transport Error: %@
        static func transportError(_ p1: String) -> String {
            return Strings.tr("Localizable", "NetworkError.transportError", p1)
        }
        /// Unknown Error: %@
        static func unknown(_ p1: String) -> String {
            return Strings.tr("Localizable", "NetworkError.unknown", p1)
        }
        /// Untreated Status Code: %@
        static func untreatedCode(_ p1: Int) -> String {
            return Strings.tr("Localizable", "NetworkError.untreatedCode", p1)
        }
        /// App needs to update
        static let upgradeRequired = Strings.tr("Localizable", "NetworkError.upgradeRequired")
    }
}


extension Strings {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = GenericNetworkLayerResources.resourcesBundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}
