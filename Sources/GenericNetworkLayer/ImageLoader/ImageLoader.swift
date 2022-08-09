#if !os(macOS)

import Core
import UIKit
import Foundation

public protocol ImageLoading {
    func download(from url: URL, willDownloadImage: (@escaping () -> Void), completion: @escaping ((UIImage?) -> Void))
    func cancelRequest()
    func cacheImage(from url: URL)
}

public final class ImageLoader: ImageLoading {
    private var dataTask: URLSessionDataTaskable?
    private let session: URLSessionable
    private let imageCache: ImageCaching

    public init(urlSession: URLSessionable = URLSession.shared, imageCache: ImageCaching = ImageCacher.shared) {
        self.session = urlSession
        self.imageCache = imageCache
    }

    public func download(from url: URL, willDownloadImage: (@escaping () -> Void), completion: @escaping ((UIImage?) -> Void)) {
        if let cachedImage = imageCache.loadImage(for: url.absoluteString as NSString) {
            completion(cachedImage)
            return
        }

        willDownloadImage()
        
        dataTask = session.dataTask(with: url) { [imageCache] data, _, _ in
            guard let data = data, let image = UIImage(data: data) else { return }
            imageCache.cache(image: image, withKey: url.absoluteString as NSString)
            completion(image)
        }
        dataTask?.resume()
    }

    public func cancelRequest() {
        dataTask?.cancel()
    }
    
    public func cacheImage(from url: URL) {
        dataTask = session.dataTask(with: url) { [imageCache] data, _, _ in
            guard let data = data, let image = UIImage(data: data) else { return }
            imageCache.cache(image: image, withKey: url.absoluteString as NSString)
        }
        dataTask?.resume()
    }
}

#endif
