import XCTest
@testable import GenericNetworkLayer

final class JSONFileDecoder {
    private var decoder: JSONDecodable
    
    init(decoder: JSONDecodable = JSONDecoderMock()) {
        self.decoder = decoder
    }
    
    func loadResource<Model: Decodable>(resource: String, decodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys) throws -> Model {
        decoder.keyDecodingStrategy = decodingStrategy
        let bundle = Bundle(for: type(of: self))
        let path = try XCTUnwrap(bundle.path(forResource: resource, ofType: "json"))
        let url = URL(fileURLWithPath: path)
        let data = try Data(contentsOf: url, options: .mappedIfSafe)
        
        return try decoder.decode(Model.self, from: data)
    }
    
    func loadJson(with resource: String) -> Data {
        var data = Data()
        let bundle = Bundle.module
        if let path = bundle.path(forResource: resource, ofType: "json") {
            do {
                let fileUrl = URL(fileURLWithPath: path)
                data = try Data(contentsOf: fileUrl, options: .mappedIfSafe)
            } catch let error {
                print("parse error: \(error.localizedDescription)")
            }
        } else {
            print("Invalid filename/path.")
        }
        return data
    }
    
}
