//
//  File.swift
//  
//
//  Created by Jessica Lewinter on 05/08/22.
//

import Foundation

protocol ImageLoading {
    
}

final class ImageLoader {
    private let session: URLSessionable
    
    var dataTask: URLSessionDataTaskable?
    
    init(
        session: URLSessionable
    ) {
        self.session = session
    }
}

struct Config {
    let countLimit: Int
    let memoryLimit: Int

    static let defaultConfig = Config(countLimit: 100, memoryLimit: 1024 * 1024 * 100) // 100 MB
}
