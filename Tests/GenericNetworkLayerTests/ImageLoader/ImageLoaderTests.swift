import XCTest
@testable import GenericNetworkLayer

final class ImageLoaderTests: XCTestCase {

    func testDownloadImage_WithSuccessDownloadAndUsingCache_ShouldReturnImage() throws {
        // Given
        let imageMock = UIImage()
        let (sut, doubles) = makeSut(image: imageMock)
        let inputURL = "www.google.com"
        let url = try XCTUnwrap(URL(string: inputURL))
        
        // When
        var resultMock: Result<UIImage, NetworkError>?
        
        sut.download(from: url) { resultMock = $0 }

        // Then
        XCTAssertEqual(resultMock, .success(imageMock))
        XCTAssertEqual(doubles.imageCacheSpy.messages, [.loadImage(key: "www.google.com")])
        XCTAssertEqual(doubles.dataTaskSpy.messages, [])
    }
    
    func testDownloadImage_WithSuccessDownloadAndNotUsingCache_ShouldReturnImage() throws {
        // Given
        let (sut, doubles) = makeSut(image: nil)
        let inputURL = "www.google.com"
        let url = try XCTUnwrap(URL(string: inputURL))
        
        // When
        sut.download(from: url) { _ in }

        // Then
        XCTAssertEqual(doubles.imageCacheSpy.messages, [.loadImage(key: "www.google.com")])
        XCTAssertEqual(doubles.dataTaskSpy.messages, [.resume])
    }
}

extension ImageLoaderTests {
    typealias Doubles = (
        dataTaskSpy: URLSessionDataTaskSpy,
        urlSessionMock: URLSessionMock,
        imageCacheSpy: ImageCacheSpy
    )
    
    func makeSut(image: UIImage? = UIImage()) -> (ImageLoading, Doubles) {
        let dataTaskSpy = URLSessionDataTaskSpy()
        let urlSessionMock = URLSessionMock(dataTask: dataTaskSpy)
        let imageCacheSpy = ImageCacheSpy(image: image)
        let sut = ImageLoader(urlSession: urlSessionMock, imageCache: imageCacheSpy)
        
        return (
            sut, (
                dataTaskSpy,
                urlSessionMock,
                imageCacheSpy
            )
        )
    }
}
