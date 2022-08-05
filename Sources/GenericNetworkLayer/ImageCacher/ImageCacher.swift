#if !os(macOS)
import UIKit

public protocol ImageCaching {
    func loadImage(for key: NSString) -> UIImage?
    func cache(image: UIImage, withKey key: NSString)
    func clear(for key: NSString)
    func clearAll()
}

public final class ImageCacher: ImageCaching {
    public static let shared = ImageCacher()
    
    private let cache = NSCache<NSString, UIImage>()

    public func loadImage(for key: NSString) -> UIImage? {
        cache.object(forKey: key)
    }
    
    public func cache(image: UIImage, withKey key: NSString) {
        cache.setObject(image, forKey: key)
    }
    
    public func clear(for key: NSString) {
        cache.removeObject(forKey: key)
    }
    
    public func clearAll() {
        cache.removeAllObjects()
    }
}

#endif
