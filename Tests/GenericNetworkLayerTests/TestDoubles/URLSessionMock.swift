import Foundation
import GenericNetworkLayer

final class URLSessionMock: URLSessionable {
    private let dataTask: URLSessionDataTaskable
    private let fileDecoder = JSONFileDecoder()
    
    lazy var response: HTTPURLResponse = createResponse(statusCode: 200)

    init(dataTask: URLSessionDataTaskable) {
        self.dataTask = dataTask
    }
    
    func dataTask(request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskable {
        completionHandler(fileDecoder.loadJson(with: "result"), response, nil)
        
        return dataTask
    }
    
    func dataTask(url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskable {
        completionHandler(fileDecoder.loadJson(with: "result"), response, nil)

        return dataTask
    }
    
    func createResponse(statusCode: Int) -> HTTPURLResponse {
        guard let url = URL(string: "https://www.mockurl.com") else {
            fatalError("URL can't be empty")
        }
        let response = HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: nil, headerFields: nil)!
        
        return response
    }
}
