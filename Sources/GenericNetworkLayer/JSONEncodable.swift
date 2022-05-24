import Foundation

protocol JSONEncodable {
    var outputFormatting: JSONEncoder.OutputFormatting { get set }
    var keyEncodingStrategy: JSONEncoder.KeyEncodingStrategy { get set }
    
    func encode<T: Encodable>(_ value: T) throws -> Data
}

extension JSONEncoder: JSONEncodable {}
