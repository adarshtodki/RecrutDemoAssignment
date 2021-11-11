import Foundation
import UIKit

typealias DownloadCompletion = ((_ image: UIImage?, _ urlString: String) -> ())?

class ImageProvider {
    
    private let networkLayer: NetworkLayer
    private let queue = DispatchQueue(label: "imageDownloading", attributes: .concurrent)
    private let cache = ImageCache()
    
    init() {
        self.networkLayer = NetworkLayer.sharedInstance
    }
    
    func imageAsync(from urlString: String, completion: DownloadCompletion) {
        
        guard let url = URL(string: urlString) else {
            completion?(nil, urlString)
            return
        }
        
        let imageName = self.imageName(for: url)
        queue.async { [weak self] in
            self?.downloadImage(from: url, saveAs: imageName, completion: { (image, urlString) in
                DispatchQueue.main.async { () -> Void in
                    completion?(image, urlString)
                }
            })
        }
    }

    private func downloadImage(from url: URL, saveAs imageName: String, completion: DownloadCompletion) {
        let urlString = url.absoluteString
        
        if let localImage = self.cache.fetchImage(remoteURL: url) {
            completion?(localImage, urlString)
        } else {
            networkLayer.downloadFile(from: url, completion: { (locationURL, response, error) in
                
                guard let location = locationURL else {
                    completion?(nil, urlString)
                    return
                }
                
                if let image = self.cache.storeImageInCache(from: location, remoteURL: url) {
                    completion?(image, urlString)
                } else {
                    completion?(nil, urlString)
                }
            })
        }
    }
    
    func imageName(for url: URL) -> String {
        var imageName = url.lastPathComponent
        if let size = url.query {
            imageName = imageName + size
        }
        return imageName
    }
}
























