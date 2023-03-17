//
//  Parser.swift
//  
//
//  Created by Jessica Lewinter on 17/01/23.
//

import Foundation

protocol Parsing {
    func parse<T: Decodable>(type: T.Type, data: Data) -> Result<T, Error>
}

final class Parser: Parsing {
    private let decoder: JSONDecodable
    
    init(decoder: JSONDecodable) {
        self.decoder = decoder
    }

    func parse<T: Decodable>(type: T.Type, data: Data) -> Result<T, Error> {
        do {
            let decodedObject = try decoder.decode(type, from: data)
            return .success(decodedObject)
        } catch {
            return .failure(NetworkError.decodeFailure(error))
        }
    }
}
