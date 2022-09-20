//
//  File.swift
//  
//
//  Created by Jessica Lewinter on 15/08/22.
//

import Foundation
@testable import GenericNetworkLayer

final class DispatchQueueMock: Dispatching {
    func async(execute work: @escaping () -> Void) {
        work()
    }
    
    func asyncAfter(after: DispatchTime, execute work: DispatchWorkItem) {
        work.perform()
    }
    
    
}
