import Foundation

public protocol Dispatching {
    func async(execute work: @escaping () -> Void)
    func global(qos: DispatchQoS.QoSClass) -> Dispatching
    func asyncAfter(after: DispatchTime, execute work: DispatchWorkItem)
}

extension DispatchQueue: Dispatching {
    public func async(execute work: @escaping () -> Void) {
        async(group: nil, execute: work)
    }

    public func global(qos: DispatchQoS.QoSClass) -> Dispatching {
        global(qos: qos)
    }
    
    public func asyncAfter(after: DispatchTime, execute work: DispatchWorkItem) {
        asyncAfter(deadline: after, execute: work)
    }
}
