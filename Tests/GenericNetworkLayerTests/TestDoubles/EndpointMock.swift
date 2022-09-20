import Foundation
@testable import GenericNetworkLayer

final class EndpointMock: Endpoint {
    private let givenBaseURL: URL
    private let givenPath: String
    
    init(givenBaseURL: URL, givenPath: String) {
        self.givenBaseURL = givenBaseURL
        self.givenPath = givenPath
    }
    
    var baseURL: URL {
        givenBaseURL
    }
    
    var path: String {
        givenPath
    }
    
    var method: HTTPMethod {
        .get
    }
    
    var task: Task {
        .requestPlain
    }
    
    var headers: Headers? {
        nil
    }
    
    var parametersEncoding: ParametersEncoding {
        .url
    }
}
