import Foundation

extension Encodable {
    public func prepareBody(strategy: JSONEncoder.KeyEncodingStrategy = .useDefaultKeys) -> Data? {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted
        jsonEncoder.keyEncodingStrategy = strategy

        do {
            return try jsonEncoder.encode(self)
        } catch {
            print("Failure to prepare card payload. \(error)")
            return nil
        }
    }
}

final class EncoderAdapter {
    public var jsonEncoder: JSONEncodable
    
    init(jsonEncoder: JSONEncodable) {
        self.jsonEncoder = jsonEncoder
    }
    
    func prepareBody<T: Encodable>(with payload: T, strategy: JSONEncoder.KeyEncodingStrategy = .useDefaultKeys) -> Data? {
//        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted
        jsonEncoder.keyEncodingStrategy = strategy

        do {
            return try jsonEncoder.encode(payload)
        } catch {
            print("Failure to prepare card payload. \(error)")
            return nil
        }
    }
}
