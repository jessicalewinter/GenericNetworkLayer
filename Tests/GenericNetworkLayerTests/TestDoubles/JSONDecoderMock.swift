import Foundation
@testable import GenericNetworkLayer

private enum DecodeMockError: Error {
    case doNotConformToModel
}

private struct ModelMockRequest: Decodable {
    let id: Int
    let name: String
}

private extension ModelMockRequest {
    static func fixture(
        id: Int = 42,
        name: String = "Test Mock"
    ) -> ModelMockRequest {
        .init(id: id, name: name)
    }
}

final class JSONDecoderMock: JSONDecodable {
    private let type: ModelMockRequest = .fixture()
    var keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys

    lazy var result: Result<Any, Error> = .success(type)

    func decode<Model: Decodable>(_ type: Model.Type, from data: Data) throws -> Model {
        switch result {
        case let .success(resultValue):
            guard let resultValue = resultValue as? Model else {
                throw DecodeMockError.doNotConformToModel
            }
            return resultValue
        case let .failure(error):
            throw error
        }
    }
}
