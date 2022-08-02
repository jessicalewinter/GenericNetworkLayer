import Foundation

final class GenericNetworkLayerResources {
    static let resourcesBundle: Bundle = {
        let bundle: Bundle = Bundle(for: GenericNetworkLayerResources.self)
        guard let url: URL = bundle.url(
            forResource: "GenericNetworkLayerResources",
            withExtension: "bundle"
        ) else {
            return bundle
        }
        
        return Bundle(url: url) ?? bundle
    }()
}
