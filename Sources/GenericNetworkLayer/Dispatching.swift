import Foundation

public protocol Dispatching {
    func async(execute work: @escaping () -> Void)
    func asyncAfter(after: DispatchTime, execute work: DispatchWorkItem)
}

extension DispatchQueue: Dispatching {
    public func async(execute work: @escaping () -> Void) {
        async(group: nil, execute: work)
    }
    
    public func asyncAfter(after: DispatchTime, execute work: DispatchWorkItem) {
        asyncAfter(deadline: after, execute: work)
    }
}
