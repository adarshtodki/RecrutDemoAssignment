import Foundation
import UIKit

class ImageCache {
    
    let fileManager = FileManager.default
    let cachesPath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
    var cacheSize = 70
    
    private var localCache = Dictionary<String, UIImage>()
    private let queue = DispatchQueue(label: "ImageCache", attributes: .concurrent)
    
    private func moveImage(from: URL, to destinationURL: URL) -> String? {
        
        do {
            try self.fileManager.moveItem(at: from, to: destinationURL)
        } catch {
            let er = error as NSError
            if er.code == NSFileWriteFileExistsError {
              
                return destinationURL.path
            }
            debugPrint("Download image error \(error)")
            return nil
        }
        
        return destinationURL.path
    }
    
    private func save(image: UIImage, to destinationURL: URL) {
        
        do {
            let binaryData = image.pngData()
            try binaryData?.write(to: destinationURL, options: .atomicWrite)
        } catch {
            debugPrint("Saving image error \(error)")
            let er = error as NSError
            if er.code == NSFileWriteFileExistsError {
                
            }
        }
    }
    
    func imageName(for url: URL) -> String {
    
        var imageName = url.lastPathComponent
        if let size = url.query {
            imageName = imageName + size
        }
        return imageName
    }
    
    func destinationURL(for url: URL) -> URL {
        let imageName = self.imageName(for: url)
        return self.cachesPath.appendingPathComponent(imageName)
    }
    
    func destinationURL(for imageName: String) -> URL {
        return self.cachesPath.appendingPathComponent(imageName)
    }
    
    private func setImageCache(image: UIImage, url: URL) {
        let key = self.imageName(for: url)
        queue.sync(flags: .barrier) {
            localCache[key] = image//store in cache
        }
    }
    
    private func getCachedImage(url: URL) -> UIImage? {
        let key = self.imageName(for: url)
        return queue.sync {
            return localCache[key]
        }
    }
    
    func storeImageInCache(from location: URL, remoteURL: URL) -> UIImage? {
        let imageName = self.imageName(for: remoteURL)
        let destination = destinationURL(for: imageName)
        guard let imagePath = moveImage(from: location, to: destination) else {
            return nil
        }
        return UIImage(contentsOfFile: imagePath)
    }
    
    func fetchImage(remoteURL: URL) -> UIImage? {
        if let cachedImage = getCachedImage(url: remoteURL) {
            return cachedImage
        } else {
            let imageName = self.imageName(for: remoteURL)
            let destination = destinationURL(for: imageName)
            if let localImage = UIImage(contentsOfFile: destination.path) {
                setImageCache(image: localImage, url: remoteURL)
                return localImage
            } else {
                return nil
            }
        }
    }
}
