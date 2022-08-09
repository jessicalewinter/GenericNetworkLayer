
import GenericNetworkLayer

final class URLSessionDataTaskSpy: URLSessionDataTaskable {
    enum Message {
        case resume
        case cancel
    }

    private(set) var messages: [Message] = []
    
    func resume() {
        messages.append(.resume)
    }
    
    func cancel() {
        messages.append(.cancel)
    }
}
