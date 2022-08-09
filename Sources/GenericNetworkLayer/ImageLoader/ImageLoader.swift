import UIKit
import Foundation

public protocol ImageLoading {
    func download(from url: URL, completion: @escaping (Result<UIImage, NetworkError>) -> Void)
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

    public func download(from url: URL, completion: @escaping (Result<UIImage, NetworkError>) -> Void) {
        if let cachedImage = imageCache.loadImage(for: url.absoluteString as NSString) {
            return completion(.success(cachedImage))
        }
        
        dataTask = session.dataTask(url: url) { [imageCache] data, _, error in
            if let error = error {
                completion(.failure(.transportError(error)))
            }
            
            guard let data = data else {
                return completion(.failure(.noData))
            }
                    
            guard let image = UIImage(data: data) else {
                return completion(.failure(.convertDataToImageFailed(data)))
            }
            
            imageCache.cache(image: image, withKey: url.absoluteString as NSString)
            completion(.success(image))
        }
        
        dataTask?.resume()
    }

    public func cancelRequest() {
        dataTask?.cancel()
    }
    
    public func cacheImage(from url: URL) {
        dataTask = session.dataTask(url: url) { [imageCache] data, _, _ in
            guard let data = data, let image = UIImage(data: data) else { return }
            imageCache.cache(image: image, withKey: url.absoluteString as NSString)
        }
        dataTask?.resume()
    }
}

