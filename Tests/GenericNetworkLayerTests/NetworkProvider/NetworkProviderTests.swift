import XCTest
@testable import GenericNetworkLayer

final class NetworkProviderTests: XCTestCase {

    func testRequest_WithSuccessModel_ShouldCallResume() throws {
        // Given
        let (sut, doubles) = makeSUT()
        let urlInput = try XCTUnwrap(URL(string: "http://some.niceuri.com/"))
        let pathInput = "path/to/string"
        let endpointMock = EndpointMock(givenBaseURL: urlInput, givenPath: pathInput)
        var resultMock: (Result<SuccessModelMock, NetworkError>)?
        let expectedOutput = SuccessModelMock(screen: "Success")
        
        // When
        doubles.decoderMock.result = .success(expectedOutput)
        sut.request(type: SuccessModelMock.self, endpoint: endpointMock) { resultMock = $0 }
        
        // Then
        XCTAssertEqual(resultMock, .success(expectedOutput))
        XCTAssertEqual(doubles.dataTaskSpy.messages, [.resume])
    }
    
    func testRequest_WithWrongModel_ShouldNotCallResume() throws {
        // Given
        let (sut, doubles) = makeSUT()
        let urlInput = try XCTUnwrap(URL(string: "http://some.niceuri.com/"))
        let pathInput = "path/to/string"
        let endpointMock = EndpointMock(givenBaseURL: urlInput, givenPath: pathInput)
        var resultMock: (Result<WrongModelMock, NetworkError>)?
        let expectedOutput = WrongModelMock(failure: "Wrong Model")
        
        // When
        doubles.decoderMock.result = .failure(NetworkError.connectionFailure)
        sut.request(type: WrongModelMock.self, endpoint: endpointMock) { resultMock = $0 }
        
        // Then
        XCTAssertEqual(resultMock, .failure(.decodeFailure(NetworkError.connectionFailure)))
        XCTAssertEqual(doubles.dataTaskSpy.messages, [.resume])
    }

    
    func testRequest_WithSuccessModelAndExpectation_ShouldCallResume() throws {
        // Given
        let (sut, doubles) = makeSUT()
        let urlInput = try XCTUnwrap(URL(string: "http://some.niceuri.com/"))
        let pathInput = "path/to/string"
        let endpointMock = EndpointMock(givenBaseURL: urlInput, givenPath: pathInput)
        let expectedOutput = SuccessModelMock(screen: "Success")
        let expectation = expectation(description: "Waiting for result")
        
        // When
        doubles.decoderMock.result = .success(expectedOutput)
        sut.request(type: SuccessModelMock.self, endpoint: endpointMock) { (result) in
            switch result {
            case .failure(let error):
                XCTFail("Should not fail with error: \(error)")
            case .success(let model):
                print(model)
                expectation.fulfill()
            }
        }
        
        // Then
        wait(for: [expectation], timeout: 0.1)
        XCTAssertEqual(doubles.dataTaskSpy.messages, [.resume])
    }
}

private extension NetworkProviderTests {
    typealias Doubles = (
        sessionMock: URLSessionMock,
        dispatchQueueMock: DispatchQueueMock,
        dataTaskSpy: URLSessionDataTaskSpy,
        decoderMock: JSONDecoderMock
    )
    
    func makeSUT() -> (NetworkProvider, Doubles) {
        let dataTaskSpy = URLSessionDataTaskSpy()
        let sessionMock = URLSessionMock(dataTask: dataTaskSpy)
        let dispatchQueueMock = DispatchQueueMock()
        let decoderMock = JSONDecoderMock()
        
        let sut = NetworkProvider(
            session: sessionMock,
            globalQueue: dispatchQueueMock,
            decoder: decoderMock
        )
        
        return (
            sut,
            (sessionMock, dispatchQueueMock, dataTaskSpy, decoderMock)
        )
    }
}
