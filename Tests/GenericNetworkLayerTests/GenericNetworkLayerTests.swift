import XCTest
import class Foundation.Bundle
@testable import GenericNetworkLayer

final class GenericNetworkLayerTests: XCTestCase {
    
}

protocol TowersNetworkSessionProtocol {
    func execute(url: URL?, completion: @escaping (Result<Data, Error>) -> ())
}

enum TowerNetworkError: Error {
    case invalidURL
    case missingData
}

class TowersNetworkSession: TowersNetworkSessionProtocol {
    func execute(url: URL?, completion: @escaping (Result<Data, Error>) -> ()) {
        guard let url = url else {
            completion(.failure(TowerNetworkError.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
            }
            
            if let data = data {
                completion(.success(data))
            } else {
                completion(.failure(TowerNetworkError.missingData))
            }
        }
        .resume()
    }
}

class TowersMockNetworkSession: TowersNetworkSessionProtocol {
    var completion: Result<Data, Error>?
    
    func execute(url: URL?, completion: @escaping (Result<Data, Error>) -> ()) {
        guard url != nil else {
            completion(.failure(TowerNetworkError.invalidURL))
            return
        }
        
        self.completion.map(completion)
    }
}

struct Tower: Codable, Equatable {
    let name: String
}

class TowersDataManager {
    private let session: TowersNetworkSessionProtocol
    
    init(session: TowersNetworkSessionProtocol) {
        self.session = session
    }
    
    func tallestTowers(completion: @escaping (Result<[Tower], Error>) -> ()) {
        let url = URL(string: "https://tower.free.beeceptor.com/tallest")
        
        session.execute(url: url) { result in
            switch result {
            case .success(let data):
                let result = Result(catching: {
                    try JSONDecoder().decode([Tower].self, from: data)
                })
                completion(result)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

class TestandoTests: XCTestCase {
    func testTallestTowersData() throws {
      // 1
      var result: Result<[Tower], Error>?

      // 2
      let tallestTowers: [Tower] = [Tower(name: "hello")]
      let response = try JSONEncoder().encode(tallestTowers)

      // 3
      let session = TowersMockNetworkSession()
      session.completion = .success(response)

      // 4
      let dataManager = TowersDataManager(session: session)

      // 5
      dataManager.tallestTowers {
        result = $0
      }

      // 6d
      XCTAssertEqual(try result?.get(), tallestTowers)
    }
}
