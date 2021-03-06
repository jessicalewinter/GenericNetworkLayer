import XCTest
import class Foundation.Bundle
@testable import GenericNetworkLayer
final class GenericNetworkLayerTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.

        // Some of the APIs that we use below are available in macOS 10.13 and above.
        guard #available(macOS 10.13, *) else {
            return
        }

        // Mac Catalyst won't have `Process`, but it is supported for executables.
        #if !targetEnvironment(macCatalyst)

        let fooBinary = productsDirectory.appendingPathComponent("GenericNetworkLayer")

        let process = Process()
        process.executableURL = fooBinary

        let pipe = Pipe()
        process.standardOutput = pipe

        try process.run()
        process.waitUntilExit()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)

        XCTAssertEqual(output, "Hello, world!\n")
        #endif
    }
    
    struct Blogger {
        func makeHeadline(from input: String) -> String {
            input.capitalized
        }
    }
    
    func test_makeHeadline_shouldShowCapitalizeAllStrings() {
        // Given
        let blogger = Blogger()
        let input: String = "hello mama"
        let expectedResult: String = "Hello Mama"
        
        // When
        let result = blogger.makeHeadline(from: input)
        
        // Then
        XCTAssertEqual(result, expectedResult)
    }

    /// Returns path to the built products directory.
    var productsDirectory: URL {
      #if os(macOS)
        for bundle in Bundle.allBundles where bundle.bundlePath.hasSuffix(".xctest") {
            return bundle.bundleURL.deletingLastPathComponent()
        }
        fatalError("couldn't find the products directory")
      #else
        return Bundle.main.bundleURL
      #endif
    }
}
