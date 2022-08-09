//
//  File.swift
//  
//
//  Created by Jessica Lewinter on 09/08/22.
//

import Foundation
import GenericNetworkLayer

final class URLSessionMock: URLSessionable {
    private let dataTask: URLSessionDataTaskable
    
    init(dataTask: URLSessionDataTaskable) {
        self.dataTask = dataTask
    }
    
    func dataTask(request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskable {
        dataTask
    }
    
    func dataTask(url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskable {
        dataTask
    }
}
