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
    
    func testRequest_WithWrongModelAndDecoderResultFailure_ShouldCallResumeAndReturnResultWithFailure() throws {
        // Given
        let (sut, doubles) = makeSUT()
        let urlInput = try XCTUnwrap(URL(string: "http://some.niceuri.com/"))
        let pathInput = "path/to/string"
        let endpointMock = EndpointMock(givenBaseURL: urlInput, givenPath: pathInput)
        var resultMock: (Result<WrongModelMock, NetworkError>)?
        
        // When
        doubles.decoderMock.result = .failure(NetworkError.connectionFailure)
        sut.request(type: WrongModelMock.self, endpoint: endpointMock) { resultMock = $0 }
        
        // Then
        XCTAssertEqual(resultMock, .failure(.decodeFailure(NetworkError.connectionFailure)))
        XCTAssertEqual(doubles.dataTaskSpy.messages, [.resume])
    }
    
    func testRequest_WhenResponseWithStatusCode4XXAndSuccessModel_ShouldCallResumeAndReturnResultWithClientErrorFailure() throws {
        // Given
        let (sut, doubles) = makeSUT()
        
        let urlInput = try XCTUnwrap(URL(string: "http://some.niceuri.com/"))
        let pathInput = "path/to/string"
        let endpointMock = EndpointMock(givenBaseURL: urlInput, givenPath: pathInput)
        var resultMock: (Result<SuccessModelMock, NetworkError>)?
        let inputStatusCode = 400
        let dataResponseMock = JSONFileDecoder().loadJson(with: "result")
        let dataString: String = String(bytes: dataResponseMock, encoding: .utf8) ?? "Error parsing mock data"
        let clientError: NetworkError = .clientError(inputStatusCode, dataString)

        // When
        doubles.decoderMock.result = .failure(clientError)
        doubles.sessionMock.response = doubles.sessionMock.createResponse(statusCode: inputStatusCode)
        sut.request(type: SuccessModelMock.self, endpoint: endpointMock) { resultMock = $0 }
        
        // Then
        XCTAssertEqual(resultMock, .failure(clientError))
        XCTAssertEqual(doubles.dataTaskSpy.messages, [.resume])
    }
    
    func testRequest_WhenResponseWithStatusCode5XXAndSuccessModel_ShouldCallResumeAndReturnResultWithClientErrorFailure() throws {
        // Given
        let (sut, doubles) = makeSUT()
        
        let urlInput = try XCTUnwrap(URL(string: "http://some.niceuri.com/"))
        let pathInput = "path/to/string"
        let endpointMock = EndpointMock(givenBaseURL: urlInput, givenPath: pathInput)
        var resultMock: (Result<SuccessModelMock, NetworkError>)?
        let inputStatusCode = 500
        let dataResponseMock = JSONFileDecoder().loadJson(with: "result")
        let dataString: String = String(bytes: dataResponseMock, encoding: .utf8) ?? "Error parsing mock data"
        let serverError: NetworkError = .serverError(inputStatusCode, dataString)

        // When
        doubles.decoderMock.result = .failure(serverError)
        doubles.sessionMock.response = doubles.sessionMock.createResponse(statusCode: inputStatusCode)
        sut.request(type: SuccessModelMock.self, endpoint: endpointMock) { resultMock = $0 }
        
        // Then
        XCTAssertEqual(resultMock, .failure(serverError))
        XCTAssertEqual(doubles.dataTaskSpy.messages, [.resume])
    }
    
    // The testes below were created only for learning purposes, I wanted to see how different these tests behaves with/wihtout expectation.
    func testRequest_WithSuccessModelAndExpectation_ShouldCallResume() throws {
        // Given
        let (sut, doubles) = makeSUT()
        let urlInput = try XCTUnwrap(URL(string: "http://some.niceuri.com/"))
        let pathInput = "path/to/string"
        let endpointMock = EndpointMock(givenBaseURL: urlInput, givenPath: pathInput)
        var resultMock: (Result<SuccessModelMock, NetworkError>)?
        let expectedOutput = SuccessModelMock(screen: "Success")
        let expectation = expectation(description: "Waiting for result")
        
        // When
        doubles.decoderMock.result = .success(expectedOutput)
        sut.request(type: SuccessModelMock.self, endpoint: endpointMock) { result in
            resultMock = result
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
        XCTAssertEqual(resultMock, .success(expectedOutput))
        XCTAssertEqual(doubles.dataTaskSpy.messages, [.resume])
    }

    func testRequest_WithWrongModelAndExpectation_ShouldCallResume() throws {
        // Given
        let (sut, doubles) = makeSUT()
        let urlInput = try XCTUnwrap(URL(string: "http://some.niceuri.com/"))
        let pathInput = "path/to/string"
        let endpointMock = EndpointMock(givenBaseURL: urlInput, givenPath: pathInput)
        var resultMock: (Result<WrongModelMock, NetworkError>)?
        let expectation = expectation(description: "Waiting for result")
        
        // When
        doubles.decoderMock.result = .failure(NetworkError.connectionFailure)
        
        sut.request(type: WrongModelMock.self, endpoint: endpointMock) { result in
            resultMock = result
            switch result {
            case .failure(let error):
                print(error)
                expectation.fulfill()
            case .success(let model):
                print(model)
                XCTFail("Should not fail with model: \(model)")
            }
        }
        
        // Then
        wait(for: [expectation], timeout: 0.1)
        XCTAssertEqual(resultMock, .failure(.decodeFailure(NetworkError.connectionFailure)))
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
