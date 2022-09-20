import Foundation

public protocol JSONDecodable {
    var keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy { get set }

    /// Decodes a top-level value of the given type from the given JSON representation.
    ///
    /// - parameter type: The type of the value to decode.
    /// - parameter data: The data to decode from.
    /// - returns: A value of the requested type.
    /// - throws: `DecodingError.dataCorrupted` if values requested from the payload are corrupted, or if the given data is not valid JSON.
    /// - throws: An error if any value throws an error during decoding.
    func decode<Model: Decodable>(_ type: Model.Type, from data: Data) throws -> Model
}

extension JSONDecoder: JSONDecodable {}

extension JSONDecoder {
    public convenience init(_ decodingStrategy: JSONDecoder.KeyDecodingStrategy) {
        self.init()
        keyDecodingStrategy = decodingStrategy
    }
}
