import Foundation

extension Encodable {
    public func prepareBody(strategy: JSONEncoder.KeyEncodingStrategy = .useDefaultKeys) -> Data? {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted
        jsonEncoder.keyEncodingStrategy = strategy

        do {
            return try jsonEncoder.encode(self)
        } catch {
            print("Failure to prepare payload. \(error)")
            return nil
        }
    }
}

extension Encodable {
    /// Encode into JSON and return `Data`
    public func jsonData(strategy: JSONEncoder.KeyEncodingStrategy = .useDefaultKeys) throws -> Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        encoder.dateEncodingStrategy = .iso8601
        encoder.keyEncodingStrategy = strategy
        
        return try encoder.encode(self)
    }
}
