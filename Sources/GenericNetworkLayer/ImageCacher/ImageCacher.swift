import UIKit

public protocol ImageCaching {
    func loadImage(for key: NSString) -> UIImage?
    func cache(image: UIImage, withKey key: NSString)
    func clear(for key: NSString)
    func clearAll()
}

public final class ImageCacher: ImageCaching {
    private let cache = NSCache<NSString, UIImage>()

    func loadImage(for key: NSString) -> UIImage? {
        cache.object(forKey: key)
    }
    
    func cache(image: UIImage, withKey key: NSString) {
        cache.setObject(image, forKey: key)
    }
    
    func clear(for key: NSString) {
        cache.removeObject(forKey: key)
    }
    
    func clearAll() {
        cache.removeAllObjects()
    }
}



