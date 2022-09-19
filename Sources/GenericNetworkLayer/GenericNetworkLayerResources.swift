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
    
    func dataFromResource(_ resource: String) -> Data? {
        var data = Data()
        let testBundle = Bundle(for: type(of: self))
        if let path = testBundle.path(forResource: resource, ofType: "json") {
            do {
                let fileUrl = URL(fileURLWithPath: path)
                data = try Data(contentsOf: fileUrl, options: .mappedIfSafe)
            } catch let error {
                print("parse error: \(error.localizedDescription)")
            }
        } else {
            print("Invalid filename/path.")
        }
        return data
    }
}
