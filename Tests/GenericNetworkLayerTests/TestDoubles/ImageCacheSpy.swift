import UIKit
import GenericNetworkLayer

final class ImageCacheSpy: ImageCaching {
    // MARK: Initialization
    private let image: UIImage?
    
    init(image: UIImage? = UIImage()) {
        self.image = image
    }
    
    enum Message: Equatable {
        case loadImage(key: NSString)
        case cache(image: UIImage, key: NSString)
        case clear(key: NSString)
        case clearAll
    }
    
    private(set) var messages: [Message] = []
    
    @discardableResult
    func loadImage(for key: NSString) -> UIImage? {
        messages.append(.loadImage(key: key))
        return image
    }
    
    func cache(image: UIImage, withKey key: NSString) {
        messages.append(.cache(image: image, key: key))
    }
    
    func clear(for key: NSString) {
        messages.append(.clear(key: key))
    }
    
    func clearAll() {
        messages.append(.clearAll)
    }
}
