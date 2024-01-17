import UIKit

final class ImageService {

  private static let cache = NSCache<NSString, UIImage>()
  
  static func getImage(imageUrl: String?, newSize: CGSize? = nil) async -> UIImage? {
    guard let imageUrl = imageUrl else { return nil }
    
    if let cachedImage = getCachedImage(with: imageUrl) {
      return cachedImage
      
    } else {
      guard !imageUrl.isEmpty else { return nil }
      guard let url = URL(string: imageUrl) else { return nil }
      
      do {
        let (data, _) = try await URLSession.shared.data(from: url)
        guard let image = UIImage(data: data) else { return nil }
        
        let finalImage: UIImage
        if let newSize = newSize {
          if newSize.width.isZero && newSize.height.isZero {
            finalImage = image
          } else if newSize.width.isZero {
            finalImage = image.resize(toHeight: newSize.height)
          } else if newSize.height.isZero {
            finalImage = image.resize(toWidth: newSize.width)
          } else {
            finalImage = image.resize(toSize: newSize)
          }
        } else {
          finalImage = image
        }
        saveImageToCache(image: finalImage, with: imageUrl)
        return finalImage
        
      } catch {
        return nil
      }
    }
  }
  
  static func getCachedImage(with key: String) -> UIImage? {
    return self.cache.object(forKey: key as NSString)
  }
  
  static func saveImageToCache(image: UIImage, with key: String) {
    self.cache.setObject(image, forKey: key as NSString)
  }
  
  static func clearCache() {
    self.cache.removeAllObjects()
  }
}
